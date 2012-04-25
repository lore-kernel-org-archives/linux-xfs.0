Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3PJvk0O231102 for <xfs@oss.sgi.com>; Wed, 25 Apr 2012 14:57:46 -0500
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id xtPieuCMEUuVPsDX for <xfs@oss.sgi.com>;
	Wed, 25 Apr 2012 12:57:45 -0700 (PDT)
Message-ID: <4F985738.7030103@sandeen.net>
Date: Wed, 25 Apr 2012 14:57:44 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: 11.1
References: <1335383079.55171.YahooMailNeo@web126001.mail.ne1.yahoo.com>
In-Reply-To: <1335383079.55171.YahooMailNeo@web126001.mail.ne1.yahoo.com>
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
To: Paul Jones <ntdeveloper2002@yahoo.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 4/25/12 2:44 PM, Paul Jones wrote:
> I am running stock Suse 11.1, which is pretty old. Is there a way for
> me to take the latest version of the xfs code and compile it for
> 11.1, or os there a dependency on later kernel versions/Suse versions
> somehow? I am running 2.6-32..I wanted to get all the latest
> scalability and performance fixes..

backporting newer filesystems to older kernels is a nontrivial task.
Distros do it with a fair bit of effort and testing; non-fs-ninjas
usually do not.  :)

So yes, it's technically possible, but it's not a drop-in replacement.

(if you're talking about the userspace xfsprogs code, that's another
matter; newer xfsprogs & xfsdump should work fine with older kernels,
just build it and go)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
