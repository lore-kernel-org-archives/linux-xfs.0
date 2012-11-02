Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA2Ec1sC139432 for <xfs@oss.sgi.com>; Fri, 2 Nov 2012 09:38:01 -0500
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id J89R1qkL3DVlhn0x for <xfs@oss.sgi.com>;
	Fri, 02 Nov 2012 07:39:53 -0700 (PDT)
Message-ID: <5093DB39.5020409@sandeen.net>
Date: Fri, 02 Nov 2012 09:39:53 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 1/2 V2] xfs_logprint: Handle multiply-logged inode fields
References: <5092A1DE.10609@redhat.com> <5092A2B6.2000907@redhat.com>
	<5092A46A.8080909@sandeen.net>
	<20121102130132.GA12578@infradead.org>
In-Reply-To: <20121102130132.GA12578@infradead.org>
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
Cc: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On 11/2/12 8:01 AM, Christoph Hellwig wrote:
>> I've tested this by a simple test such as creating one
>> file on an selinux box, so that data+attr is set, and
>> logprinting; I've also tested by running logprint after
>> subsequent xfstest runs (although we hit other bugs that
>> way).
> 
> Can you add this test to xfstests, please?

Yeah that should be easy enough.

>> +
>> +    if (f->ilf_fields & (XFS_ILOG_DEV | XFS_ILOG_UUID)) {
>> +	switch (f->ilf_fields & (XFS_ILOG_DEV | XFS_ILOG_UUID)) {
>> +	case XFS_ILOG_DEV:
>> +	    printf(_("DEV inode: no extra region\n"));
> 
> The if here looks odd, I think you should follow the style with
> a switch on a masked value as it's done in xlog_recover_inode_pass2()
> in the kernel.

Hm TBH I'm not sure why I left that if in there.
For the DFORK/AFORK case I think the if made sense, but not for
the DEV/UUID case I think.  I'll take another look.

> I also reall hate the indentation in this function, can you thrown in
> a preparatory patch to change it to the normal one?

to 8-char tabs?  Ok

-Eric

> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
