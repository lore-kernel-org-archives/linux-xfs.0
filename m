Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CF7187F37
	for <xfs@oss.sgi.com>; Thu,  3 Jul 2014 09:14:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6A28DAC004
	for <xfs@oss.sgi.com>; Thu,  3 Jul 2014 07:14:17 -0700 (PDT)
Received: from deltamedia.de (deltamedia.de [178.77.98.209]) by cuda.sgi.com
	with ESMTP id bkq6JxmHeEbXiYEm (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 03 Jul 2014 07:14:12 -0700 (PDT)
Date: Thu, 3 Jul 2014 16:14:08 +0200
From: Matthias Schniedermeyer <ms@citd.de>
Subject: Re: Changing label of a mounted XFS filesystem
Message-ID: <20140703141408.GA17657@citd.de>
References: <20140703112911.GA9806@citd.de>
 <53B54779.40108@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <53B54779.40108@oracle.com>
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
To: Jeff Liu <jeff.liu@oracle.com>
Cc: xfs@oss.sgi.com

On 03.07.2014 20:07, Jeff Liu wrote:
> Hi,
> 
> On 07/03/2014 07:29 PM, Matthias Schniedermeyer wrote:
> > Hi
> > 
> > 
> > Is there a particular reason that the label of a mounted XFS fileystem
> > can't be changed?
> 
> Maybe since we have no user request for this function? :)
> 
> > The man-page of xfs_admin gives a blanket "Devices that are mounted
> > cannot be modified" but no explanation for why that is.
> > 
> > In my case it's the label of the root-filesystem i want to change. So to
> > change it i would have to boot the computer with some kind of live or
> > rescure-system. Or i would need to temporarily connect the device to
> > another computer, both aren't really nice hoops to jump through just to
> > change a few characters.
> > 
> > The only thing i can compare this to is ext2 and with ext2 (/boot
> > partition, so it really is ext2) i can change the label to my hearts
> > content, even the device is mounted.
> > 
> > For my case i could live with it if i could remount the filesystem RO,
> > change the label and then having to reboot the machine, still nicer than
> > the other 2 options.
> 
> Btrfs support set/change label on a mounted file system via ioctl(2), maybe we
> can implement it if that sounds useful to our users.

I would vote for that, i've run into this particular brickwall several 
times over the years.

I more or less reguarly clone or "move" storage and/or machines around 
and several times i forgot to re-label filesystems "at that point in 
time were it was easily done" and then run into the brickwall when first 
booting whatever i built at that time. Same has happend to me for 
/etc/fstab and/or GRUB configuration. But unless GRUB doesn't boot at 
all it can be rectified without too much hassle.

Yesterday i "fixed" it by changing the fstab to the "wrong" label.

The other solution would be for me to make a checklist, so i don't 
forget such things. But that would be to easy. ;-)



-- 

Matthias

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
