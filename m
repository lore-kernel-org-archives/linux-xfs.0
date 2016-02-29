Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id DD2A229E05
	for <xfs@oss.sgi.com>; Mon, 29 Feb 2016 09:29:29 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4FCF6AC001
	for <xfs@oss.sgi.com>; Mon, 29 Feb 2016 07:29:26 -0800 (PST)
Received: from prv-mh.provo.novell.com (prv-mh.provo.novell.com
	[137.65.248.74]) by cuda.sgi.com with ESMTP id 1eZ9vxOLGCLVpBok
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 29 Feb 2016 07:29:24 -0800 (PST)
Message-Id: <56D471E002000078000D76C2@prv-mh.provo.novell.com>
Date: Mon, 29 Feb 2016 08:29:20 -0700
From: "Jan Beulich" <JBeulich@suse.com>
Subject: XFS: false "torn write" errors (preventing mount)
Mime-Version: 1.0
Content-Disposition: inline
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
To: bfoster@redhat.com
Cc: xfs@oss.sgi.com

Brian,

on a system where I routinely run both a 32-bit and a 64-bit x86
kernel (underneath the same 32-bit distro) I'm observing the
newly added message being issued, along with the mounts
subsequently failing when running the 32-bit kernel. Without
doing anything to the FS, running an older 32-bit kernel or a
4.5-rc6 64-bit one have everything work fine (and silently), so
I can only assume the detection logic doesn't work right in a
32-bit kernel. I've looked over commits 6528250b71 and
7088c4136f without being able to spot any obvious word size
dependency, but then again I know nothing about the inner
workings of the XFS code.

I'm now hoping that you have an idea what's going on here.

Thanks, Jan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
