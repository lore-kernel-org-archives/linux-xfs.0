Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4HEW9l3188472 for <xfs@oss.sgi.com>; Tue, 17 May 2011 09:32:09 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E242415D4A06
	for <xfs@oss.sgi.com>; Tue, 17 May 2011 07:32:08 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id SbVcbdKZfhly6DKc for
	<xfs@oss.sgi.com>; Tue, 17 May 2011 07:32:08 -0700 (PDT)
Message-ID: <4DD286E5.8090105@redhat.com>
Date: Tue, 17 May 2011 09:32:05 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: xfstests: device busy when umount
References: <BANLkTimQW+kyqjmzpAHH_W5x2v1EWW2AZA@mail.gmail.com>
In-Reply-To: <BANLkTimQW+kyqjmzpAHH_W5x2v1EWW2AZA@mail.gmail.com>
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
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>, Amir Goldstein <amir73il@gmail.com>, xfs-oss <xfs@oss.sgi.com>

On 5/17/11 4:03 AM, Yongqiang Yang wrote:
> Hi,
> 
> I noticed that all tests which contain 'device busy' errors have
> falloc operations.  Does the error have something to do with falloc?
> 

cc'ing xfs list since xfs devs maintain xfstests.

What tests have "device busy" errors?  What do the usual investigative
steps such as "lsof" and "fuser" tell you when this happens?

Are there loop devices that didn't get cleaned up, or processes that
have not terminated?

What tests have these problems?

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
