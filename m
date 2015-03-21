Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7F66B7F37
	for <xfs@oss.sgi.com>; Fri, 20 Mar 2015 21:26:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 417F2304043
	for <xfs@oss.sgi.com>; Fri, 20 Mar 2015 19:26:17 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id LALd4nFuSGGIfPRN for <xfs@oss.sgi.com>;
	Fri, 20 Mar 2015 19:26:16 -0700 (PDT)
Message-ID: <550CD6C4.8030506@sandeen.net>
Date: Fri, 20 Mar 2015 21:26:12 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 02/13] xfs_db: fix inode CRC validity state, and warn
	on read if invalid
References: <1426624395-8258-1-git-send-email-sandeen@redhat.com>	<1426624395-8258-3-git-send-email-sandeen@redhat.com>
	<20150319150721.GB11669@laptop.bfoster>
In-Reply-To: <20150319150721.GB11669@laptop.bfoster>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>, Eric Sandeen <sandeen@redhat.com>
Cc: xfs@oss.sgi.com

On 3/19/15 10:07 AM, Brian Foster wrote:
> On Tue, Mar 17, 2015 at 03:33:04PM -0500, Eric Sandeen wrote:
>> Currently, the "ino_crc_ok" field on the io cursor reflects
>> overall inode validity, not CRC correctness.  Because it is
>> only used when printing CRC validity, change it to reflect
>> only that state - and update it whenever we re-write the
>> inode (thus updating the CRC).
>>
>> In addition, when reading an inode, warn if the CRC is bad.
>>
>> Note, when specifying an inode which doesn't actually exist,
>> this will claim corruption; I'm not sure if that's good or
>> bad. Today, it already issues corruption errors on the way;
>> this adds a new message as well:
>>
>> xfs_db> inode 129
>> Metadata corruption detected at block 0x80/0x2000
>> Metadata corruption detected at block 0x80/0x2000
>> ...
>> Metadata CRC error detected for ino 129
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
> 
> So is the objective here to simply give the field an explicit meaning?
> E.g., indicate whether the crc is valid, irrespective of whether
> something else might be wrong with the inode?

Yeah, ino_crc_ok kinda indicates that the inode... crc ... is ok? :)

Prior to this, it was only used in iocur_crc_valid(), which is called
from fp_crc() to print unchecked/bad/correct/unknown for the crc.

That's only used to print crc fields in the table-driven db stuff:

        { FLDT_CRC, "crc", fp_crc, "%#x (%s)", SI(bitsz(__uint32_t)),
          0, NULL, NULL },

so it seems to have a very specific meaning, and wrapping it up
w/ the verifier didn't make sense.

I had something more specific when I first sent the patch but that
was yonks ago.  :)

>>  db/inode.c       |    7 ++++++-
>>  db/io.c          |    4 +++-
>>  include/libxfs.h |    2 ++
>>  3 files changed, 11 insertions(+), 2 deletions(-)
>>
>> diff --git a/db/inode.c b/db/inode.c
>> index 24170ba..982acb7 100644
>> --- a/db/inode.c
>> +++ b/db/inode.c
>> @@ -684,13 +684,18 @@ set_cur_inode(
>>  		numblks, DB_RING_IGN, NULL);
>>  	off_cur(offset << mp->m_sb.sb_inodelog, mp->m_sb.sb_inodesize);
>>  	dip = iocur_top->data;
>> -	iocur_top->ino_crc_ok = libxfs_dinode_verify(mp, ino, dip);
>> +	iocur_top->ino_crc_ok = libxfs_verify_cksum((char *)dip,
>> +						    mp->m_sb.sb_inodesize,
>> +						    XFS_DINODE_CRC_OFF);
> 
> With this replaced, it doesn't look like anybody else will call
> libxfs_dinode_verify (analogous to xfs_iread() in kernel). Is that
> intentional? I guess the magic and version should be checked in the read
> verifier, but there are a couple other checks in that helper as well.

xfs_iread still calls xfs_dinode_verify, right?

>>  	iocur_top->ino_buf = 1;
>>  	iocur_top->ino = ino;
>>  	iocur_top->mode = be16_to_cpu(dip->di_mode);
>>  	if ((iocur_top->mode & S_IFMT) == S_IFDIR)
>>  		iocur_top->dirino = ino;
>>  
>> +	if (xfs_sb_version_hascrc(&mp->m_sb) && !iocur_top->ino_crc_ok)
>> +		dbprintf(_("Metadata CRC error detected for ino %lld\n"), ino);
>> +
> 
> Hmm.. if we keep this, could we combine with the hunk above? I ask
> simply because I'd rather see the _hascrc() check around the verify_cksum()
> check as well, rather than verifying a cksum and ignoring it.

ok, sure.

> It's also a little confusing how this field is handled without crc
> enabled. write_cur() looks like it sets it and calls
> libxfs_dinode_calc_crc() blindly, which asserts that crc is enabled. I
> guess we just don't print anything if crc=0, but it would be nice if the
> flag was consistent.

Hm, I can see that, but I don't know how we can test for the presence of
crcs in write_cur.  We don't have that info, AFAICT.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
