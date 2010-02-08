Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o18Jk4XN156158 for <xfs@oss.sgi.com>; Mon, 8 Feb 2010 13:46:04 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 513CF1CB1F60
	for <xfs@oss.sgi.com>; Mon,  8 Feb 2010 11:47:17 -0800 (PST)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id GuW9fyaRImZsJRMb for
	<xfs@oss.sgi.com>; Mon, 08 Feb 2010 11:47:17 -0800 (PST)
Message-ID: <4B706A44.4000804@sandeen.net>
Date: Mon, 08 Feb 2010 13:47:16 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: fix up fs_perms test used by 126
References: <4B6C4E81.6060201@sandeen.net>
	<20100208194058.GC9527@infradead.org>
In-Reply-To: <20100208194058.GC9527@infradead.org>
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
Cc: Theodore Tso <tytso@mit.edu>, xfs-oss <xfs@oss.sgi.com>

Christoph Hellwig wrote:
> On Fri, Feb 05, 2010 at 10:59:45AM -0600, Eric Sandeen wrote:
>> @@ -53,7 +53,8 @@ int main( int argc, char *argv[]) {
>>                cgroupId = atoi(argv[3]);
>>                userId = atoi(argv[4]);
>>                groupId = atoi(argv[5]);
>> -              fperm[0] = *argv[6];
>> +              strncpy(fperm, argv[6], 3);
>> +              fperm[2] = '\0';
> 
> This still looks rather weird to me.  What's the reason for copying
> the string into a fixed length buffer?  Why not leave fperm as a pointer
> to the original argument?

eh that's probably better, I guess I was just thinking copy
based on how it was before.  (which copied the char, right, it
didn't assign a pointer, unless I'm short on coffee today...)

OTOH fopen only takes 2 chars anyway.  But probably no reason to
truncate what was given, just fail if it's something that's wrong...

-Eric
 
> The rest of the patch looks fine, but a clean up pass on the whole
> file wouldn't hurt either, it's a grotty mess..
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
