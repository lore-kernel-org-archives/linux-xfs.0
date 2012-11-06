Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA6HvNhT079256 for <xfs@oss.sgi.com>; Tue, 6 Nov 2012 11:57:23 -0600
Message-ID: <50994F8A.9020907@redhat.com>
Date: Tue, 06 Nov 2012 12:57:30 -0500
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH v6 07/10] xfs: add inode id filtering to eofblocks scan
References: <1352213447-59791-1-git-send-email-bfoster@redhat.com>
	<1352213447-59791-8-git-send-email-bfoster@redhat.com>
	<50993DAC.9070100@sgi.com>
In-Reply-To: <50993DAC.9070100@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

On 11/06/2012 11:41 AM, Mark Tinguely wrote:
> On 11/06/12 08:50, Brian Foster wrote:
>> Support inode ID filtering in the eofblocks scan. The caller must
>> set the associated XFS_EOF_FLAGS_*ID bit and ID field.
>>
>> Signed-off-by: Brian Foster<bfoster@redhat.com>
>> ---
> 
> turn 0;
>>
>> +    if (eofb&&
> 
>         vvvvvvv
>> +        (eofb->eof_flags&  (XFS_EOF_FLAGS_UID|XFS_EOF_FLAGS_GID|
>> +                   XFS_EOF_FLAGS_PRID))&&
>         ^^^^^^
> Not a big deal but wouldn't xfs_inode_match_id() also check these flags?
> 

Yes it does, but at this point in the patch xfs_inode_match_id() is
implemented in an opt-in way that would alter the codepath (i.e., it
would always return 0 if no ID flags were specified and skip every inode).

I thought about defining another directive to combine the ID flags and
clean that up a bit, but as you probably noticed, the following patch
reimplements xfs_inode_match_id() such that it opts-out inodes and
allows this check in xfs_inode_free_eofblocks() to go away.

Brian

>> +        !xfs_inode_match_id(ip, eofb))
>> +        return 0;
>> +
> 
> 
> Consider this
> 
> Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
