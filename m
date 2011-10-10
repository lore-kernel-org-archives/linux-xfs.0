Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9AM4k8N207308 for <xfs@oss.sgi.com>; Mon, 10 Oct 2011 17:04:46 -0500
Received: from mail.mnsu.edu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E0515145CCBD
	for <xfs@oss.sgi.com>; Mon, 10 Oct 2011 15:11:56 -0700 (PDT)
Received: from mail.mnsu.edu (Mail.MNSU.EDU [134.29.1.12]) by cuda.sgi.com
	with ESMTP id c3aitihE5OGziA4F for <xfs@oss.sgi.com>;
	Mon, 10 Oct 2011 15:11:56 -0700 (PDT)
Received: from [134.29.32.1] (j3gum-3.ITS.MNSU.EDU [134.29.32.1])
	by mail.mnsu.edu (8.13.7/8.13.7) with ESMTP id p9AM4hP2030033
	(version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 10 Oct 2011 17:04:43 -0500
Message-ID: <4E936BFB.5060907@mnsu.edu>
Date: Mon, 10 Oct 2011 17:04:43 -0500
From: Jeffrey Hundstad <jeffrey.hundstad@mnsu.edu>
MIME-Version: 1.0
Subject: Re: TRIM on XFS
References: <201110071352.20135@zmi.at>
	<20111007233450.GK3159@dastard>	<201110100829.45823@zmi.at>
	<CAGpXXZJs8kjZaSp248rA+-d=gpwWe=oK0xtUUirv+zgE3Vq3kA@mail.gmail.com>
In-Reply-To: <CAGpXXZJs8kjZaSp248rA+-d=gpwWe=oK0xtUUirv+zgE3Vq3kA@mail.gmail.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

On 10/10/2011 03:28 PM, Greg Freemyer wrote:
> fitrim is the batch mode.
>
> To enable realtime discard, add --discard to your mount options.
>
> Documented athttp://lxr.linux.no/#linux+v3.0.4/Documentation/filesystems/xfs.txt
>
> To invoke batch mode, simply use fstrim from user space.

Hello,

I'm also trying to use FITRIM on a simple XFS partition on a spinning 
magnetic hard drive (remember those).  I haven't had much luck.  I'm 
doing this just to get used to the commands when using this against a 
thinly provisioned disk.  I have no idea if this should work in this 
configuration.

On a Debian system with Linux 3.0.0-2-amd64 when I issue:
# fstrim /

I receive:
fstrim: /: FITRIM ioctl failed: Operation not supported

With an strace this looks like:
open("/", O_RDONLY)                     = 3
ioctl(3, 0xc0185879, 0x7fff4ea851b0)    = -1 EOPNOTSUPP (Operation not 
supported)

My fstrim is from util-linux-2.19.1-5

I'd be happy to try to diagnose this further if people are interested.  
Any suggestions where I should start would be much appreciated.

-- 
Jeffrey Hundstad

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
