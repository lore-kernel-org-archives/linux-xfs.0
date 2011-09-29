Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8T0bT8Y148333 for <xfs@oss.sgi.com>; Wed, 28 Sep 2011 19:37:30 -0500
Received: from mta11.charter.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9B033142E1EE
	for <xfs@oss.sgi.com>; Wed, 28 Sep 2011 17:43:34 -0700 (PDT)
Received: from mta11.charter.net (mta11.charter.net [216.33.127.80]) by
	cuda.sgi.com with ESMTP id xdSW8OPScKVsPx5x for
	<xfs@oss.sgi.com>; Wed, 28 Sep 2011 17:43:34 -0700 (PDT)
Received: from imp11 ([10.20.200.11]) by mta11.charter.net
	(InterMail vM.7.09.02.04 201-2219-117-106-20090629) with ESMTP
	id <20110929003728.BTTH4091.mta11.charter.net@imp11>
	for <xfs@oss.sgi.com>; Wed, 28 Sep 2011 20:37:28 -0400
Message-ID: <4E83BDBC.2050108@cchtml.com>
Date: Wed, 28 Sep 2011 19:37:16 -0500
From: Michael Cronenworth <mike@cchtml.com>
MIME-Version: 1.0
Subject: Re: 64-bit inodes and back again
References: <4E825C25.6050804@cchtml.com> <20110928011020.GE3159@dastard>
	<4E8278D8.9060309@cchtml.com> <4E828BE1.8030003@cchtml.com>
	<20110928053539.GF3159@dastard> <4E82C5AF.8040203@cchtml.com>
	<20110928110726.GG3159@dastard> <4E831D81.6070102@cchtml.com>
	<20110929002511.GI3159@dastard>
In-Reply-To: <20110929002511.GI3159@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 09/28/2011 07:25 PM, Dave Chinner wrote:
> I was asking about stuff like selinux attributes, not modes and
> owners. i.e:

SELinux is enabled and in Enforcing mode. It's the default Fedora policy.

$ lsattr /var/lib/mock.save/dist-5E-build-377-1401
--------------- /var/lib/mock.save/dist-5E-build-377-1401/root

$ attr -l /var/lib/mock.save/dist-5E-build-377-1401
Attribute "selinux" has a 40 byte value for 
/var/lib/mock.save/dist-5E-build-377-1401

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
