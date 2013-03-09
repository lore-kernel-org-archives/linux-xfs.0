Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 062297F56
	for <linux-xfs@oss.sgi.com>; Sat,  9 Mar 2013 16:29:36 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CB7938F8059
	for <linux-xfs@oss.sgi.com>; Sat,  9 Mar 2013 14:29:32 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id q9Mcpf6MnEfdvlFB for
	<linux-xfs@oss.sgi.com>; Sat, 09 Mar 2013 14:29:32 -0800 (PST)
Message-ID: <513BB7C3.4050009@redhat.com>
Date: Sat, 09 Mar 2013 17:29:23 -0500
From: Ric Wheeler <rwheeler@redhat.com>
MIME-Version: 1.0
Subject: Re: Maximum file system size of XFS?
References: <20130309215121.0e614ef8@thinky>
In-Reply-To: <20130309215121.0e614ef8@thinky>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Pascal <pa5ca1@gmx.de>
Cc: linux-xfs@oss.sgi.com

On 03/09/2013 03:51 PM, Pascal wrote:
> Hello,
>
> I am asking you because I am insecure about the correct answer and
> different sources give me different numbers.
>
>
> My question is: What is the maximum file system size of XFS?
>
> The official page says: 2^63 = 9 x 10^18 = 9 exabytes
> Source: http://oss.sgi.com/projects/xfs/
>
> Wikipedia says 16 exabytes.
> Source: https://en.wikipedia.org/wiki/XFS
>
> Another reference books says 8 exabytes (2^63).
>
>
> Can anyone tell me and explain what is the maximum file system size for
> XFS?
>
>
> Thank you in advance!
>
> Pascal
>

The maximum size that XFS can address (which is what most people post in things 
like wikipedia) is kind of a fantasy number.

What is a better question is what is the maximum size XFS file system people 
have in production (even better, people who have your same work load). Lots and 
lots of tiny files are more challenging than very large video files for example.

I think that you can easily find people with 100's of terabytes in production 
use. For Red Hat, we support production use of 100TB per XFS instance in RHEL6 
for example since that is what we test at (and have been know to officially 
support larger instances by exception).

Some of the things to watch out for in very large file systems is how much DRAM 
you have in the server. If you ever need to xfs_repair a 1PB file system, you 
will need a very beefy box :)

Ric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
