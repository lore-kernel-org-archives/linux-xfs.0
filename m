Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0TMlF56239853 for <xfs@oss.sgi.com>; Thu, 29 Jan 2009 16:47:15 -0600
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id ED8A918891CE
	for <xfs@oss.sgi.com>; Thu, 29 Jan 2009 14:46:32 -0800 (PST)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id 7BMYX5d7ITkv2OU1 for <xfs@oss.sgi.com>;
	Thu, 29 Jan 2009 14:46:32 -0800 (PST)
Message-ID: <49823039.7090203@sandeen.net>
Date: Thu, 29 Jan 2009 17:39:53 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] remove remaining unused-but-installed headers
References: <1233141843.4584.40.camel@verge.scott.net.au>
	<20090129223700.GA3772@infradead.org>
In-Reply-To: <20090129223700.GA3772@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Nathan Scott <nscott@aconex.com>, xfs@oss.sgi.com

Christoph Hellwig wrote:
> On Wed, Jan 28, 2009 at 10:24:03PM +1100, Nathan Scott wrote:
>> diff --git a/include/Makefile b/include/Makefile
>> index 0403536..07076cc 100644
>> --- a/include/Makefile
>> +++ b/include/Makefile
>> @@ -29,9 +29,9 @@ QAHFILES = libxfs.h libxlog.h \
>>  	xfs_imap.h xfs_inode.h xfs_inode_item.h xfs_inum.h \
>>  	xfs_log.h xfs_log_priv.h xfs_log_recover.h xfs_metadump.h \
>>  	xfs_mount.h xfs_quota.h xfs_rtalloc.h xfs_sb.h \
>> -	xfs_trans.h xfs_trans_space.h xfs_types.h
>> +	xfs_trans.h xfs_trans_space.h xfs_types.h xfs_dfrag.h
> 
> dfrag is not needed anymore because we moved fsr to xfsprogs.
> 
>> -	$(INSTALL) -m 755 -d $(DK_INC_DIR)
>> -	$(INSTALL) -m 644 $(DKHFILES) $(DK_INC_DIR)
> 
> I think as some point libdisk was supposed to be a library others
> could use.  I don't mind if we make it private as it should be fold
> into the libvolume_id/libblkid successor in util-linux one day.

I don't know if there are plans to get the stripe size stuff into the
successor (what we have is kinda hacky) but maybe we should start that
conversation.

Keeping private should be fine, though.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
