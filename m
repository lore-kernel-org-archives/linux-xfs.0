Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n61JrJEh031156 for <xfs@oss.sgi.com>; Wed, 1 Jul 2009 14:53:19 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 297A31499232
	for <xfs@oss.sgi.com>; Wed,  1 Jul 2009 13:00:12 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id 0ysHC6c0IfLiu85n for
	<xfs@oss.sgi.com>; Wed, 01 Jul 2009 13:00:12 -0700 (PDT)
Message-ID: <4A4BBECC.8000308@sandeen.net>
Date: Wed, 01 Jul 2009 14:53:48 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Seg fault during xfs repair (segmentation fault / segv)
References: <4A4A596D.8030800@ssec.wisc.edu> <4A4A5C4E.7030605@sandeen.net>
	<4A4A7D44.7040009@ssec.wisc.edu>
In-Reply-To: <4A4A7D44.7040009@ssec.wisc.edu>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Jesse Stroik <jstroik@ssec.wisc.edu>
Cc: xfs@oss.sgi.com

Jesse Stroik wrote:
> Eric,
> 
> Eric Sandeen wrote:
>> Jesse Stroik wrote:
>>> I have a server with a ~20TB xfs file system on Linux 
>>> (2.6.18-92.1.22.el5) and am running xfsprogs-2.9.4-4.el5.  We had a few 
>>> corrupted files which I believe were due to a SCSI issue after a recent 
>>> power outage.  Due to the corruption, I ran xfs_check and would like to 
>>> run xfs_repair on the system.
>> It'd really be great to test more recent xfsprogs first, that one is
>> about 2 years old.
>>
>> You can probably grab any recent fedora src.rpm and rebuild it, and
>> later go back to the centos version if you wish.
> 
> 
> I fetched the current version from SVN using these directions: 
> http://xfs.org/index.php/Getting_the_latest_source_code
> 
> I get identical results.
> 
> --------
> ...
> reset bad sb for ag 31
> reset bad agf for ag 31
> reset bad agi for ag 31
> Segmentation fault

Ok, from a metadump image Jesse provided (thanks!) it's dying in here:

                bno = be32_to_cpu(agfl->agfl_bno[i]);
                printf("agfl at %p i is %d agfl_bno[i] %u bno is %u\n",
agfl, i, agfl->agfl_bno[i], bno);
                if (verify_agbno(mp, be32_to_cpu(agf->agf_seqno), bno))
                        set_agbno_state(mp, be32_to_cpu(agf->agf_seqno),
                                        bno, XR_E_FREE);

agfl_bno looks corrupt, and bno is coming out to be huge.

set_agbno_state() does:

*(ba_bmap[(agno)] + (ag_blockno)/XR_BB_NUM) = ....

where ag_blockno is that bno above; this wanders us off into bad memory
and boom.  I'll see what we can do to fix it up.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
