Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BA7A27CA0
	for <xfs@oss.sgi.com>; Thu,  7 Apr 2016 19:32:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8D51D8F804C
	for <xfs@oss.sgi.com>; Thu,  7 Apr 2016 17:32:39 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id TWyCEWUFYpMfAe8C for <xfs@oss.sgi.com>;
	Thu, 07 Apr 2016 17:32:37 -0700 (PDT)
Received: from [10.0.0.4] (liberator [10.0.0.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 9D860481A
	for <xfs@oss.sgi.com>; Thu,  7 Apr 2016 19:32:36 -0500 (CDT)
Subject: Re: [PATCH 15/19] mkfs: don't treat files as though they are block
	devices
References: <1458818136-56043-1-git-send-email-jtulak@redhat.com>
	<1458818136-56043-16-git-send-email-jtulak@redhat.com>
	<5706FA7C.7020103@sandeen.net>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <5706FC23.9050507@sandeen.net>
Date: Thu, 7 Apr 2016 19:32:35 -0500
MIME-Version: 1.0
In-Reply-To: <5706FA7C.7020103@sandeen.net>
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
To: xfs@oss.sgi.com



On 4/7/16 7:25 PM, Eric Sandeen wrote:
>> @@ -1299,15 +1370,23 @@ zero_old_xfs_structures(
>> >  	}
>> >  	memset(buf, 0, new_sb->sb_sectsize);
>> >  
>> > -	tmp = pread(xi->dfd, buf, new_sb->sb_sectsize, 0);
>> > -	if (tmp < 0) {
>> > +	off = pread(xi->dfd, buf, new_sb->sb_sectsize, 0);
>> > +	if (off < 0) {
>> >  		fprintf(stderr, _("existing superblock read failed: %s\n"),
>> >  			strerror(errno));
>> >  		goto done;
>> >  	}
>> > -	if (tmp != new_sb->sb_sectsize) {
>> > -		fprintf(stderr,
>> > -	_("warning: could not read existing superblock, skip zeroing\n"));
>> > +	/*
>> > +	 * If we are creating an image file, it might be of zero length at this
>> > +	 * point in time. Hence reading the existing superblock is going to
>> > +	 * return zero bytes. It's not a failure we need to warn about in this
>> > +	 * case.
>> > +	 */
> except you already did "if (off < 0) fail" above this.

(oh, right, < 0 is different than == 0, sorry; so that part is ok)

Possibly better as:

if (off < 0 || (tmp != new_sb->sb_sectsize && !xi->disfile))
	fprintf("error reading existing superblock ...")

I still think this patch might need a reset though :)

Thanks,
-Eric

> Ok, at this point I think it might be best to revert to Dave's original version.
> 
> If there were specific problems you were trying to address, can you point them out?
> 
> Thanks,
> -Eric
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
