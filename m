Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7E6D07F37
	for <xfs@oss.sgi.com>; Thu,  3 Jul 2014 07:03:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 64566304066
	for <xfs@oss.sgi.com>; Thu,  3 Jul 2014 05:03:35 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id 1lLRugag25DTurs4 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 03 Jul 2014 05:03:31 -0700 (PDT)
Message-ID: <53B54779.40108@oracle.com>
Date: Thu, 03 Jul 2014 20:07:21 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: Changing label of a mounted XFS filesystem
References: <20140703112911.GA9806@citd.de>
In-Reply-To: <20140703112911.GA9806@citd.de>
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
To: Matthias Schniedermeyer <ms@citd.de>
Cc: xfs@oss.sgi.com

Hi,

On 07/03/2014 07:29 PM, Matthias Schniedermeyer wrote:
> Hi
> 
> 
> Is there a particular reason that the label of a mounted XFS fileystem
> can't be changed?

Maybe since we have no user request for this function? :)

> The man-page of xfs_admin gives a blanket "Devices that are mounted
> cannot be modified" but no explanation for why that is.
> 
> In my case it's the label of the root-filesystem i want to change. So to
> change it i would have to boot the computer with some kind of live or
> rescure-system. Or i would need to temporarily connect the device to
> another computer, both aren't really nice hoops to jump through just to
> change a few characters.
> 
> The only thing i can compare this to is ext2 and with ext2 (/boot
> partition, so it really is ext2) i can change the label to my hearts
> content, even the device is mounted.
> 
> For my case i could live with it if i could remount the filesystem RO,
> change the label and then having to reboot the machine, still nicer than
> the other 2 options.

Btrfs support set/change label on a mounted file system via ioctl(2), maybe we
can implement it if that sounds useful to our users.


Cheers,
-Jeff
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
