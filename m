Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 30 Mar 2008 17:38:35 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m2V0cMSn028861
	for <xfs@oss.sgi.com>; Sun, 30 Mar 2008 17:38:27 -0700
Date: Mon, 31 Mar 2008 10:38:47 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: free space problem
Message-ID: <20080331003847.GF103491721@sgi.com>
References: <20080330202956.8D3D2710364@cuda.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080330202956.8D3D2710364@cuda.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: =?iso-8859-1?Q?Husz=E1r_Viktor_D=E9nes?= <hvd@dwo.hu>
Cc: xfs@oss.sgi.com

On Sun, Mar 30, 2008 at 10:29:06PM +0200, Huszár Viktor Dénes wrote:
> Hi all,
> 
> we encountered a problem with XFS free space and perhaps reserved space. It
> reports to have 82 gb free on the raid, however its not possible to write on
> the file system. Please tell me if you need more details, we have read
> through the previous free space threads, but found nothing useful. We run
> 2.6.23 kernel.

What is the error you are getting? Does 'dd if=/dev/zero of=/mntpt/file bs=512
count=1' work? If not, what's the error?  What's the output of 'df -h' and
'df -ih'? Output of 'xfs_info <mntpt>'?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
