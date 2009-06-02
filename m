Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n52GD85X111227 for <xfs@oss.sgi.com>; Tue, 2 Jun 2009 11:13:09 -0500
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6979030408F
	for <xfs@oss.sgi.com>; Tue,  2 Jun 2009 09:13:23 -0700 (PDT)
Message-Id: <7945FF47-2A9B-46D8-9A49-3D7070AAC1E8@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
In-Reply-To: <20090528145612.GA14684@infradead.org>
Mime-Version: 1.0 (Apple Message framework v926)
Subject: Re: regarding the inode64 mount option
Date: Tue, 2 Jun 2009 11:13:22 -0500
References: <4A1E81D8.7010706@dermichi.com>
	<20090528145612.GA14684@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"; DelSp="yes"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: Michael Weissenbacher <mw@dermichi.com>, xfs@oss.sgi.com

[my unsent mail from yesterday, mostly for the second blob]

On May 28, 2009, at 9:56 AM, Christoph Hellwig wrote:

> On Thu, May 28, 2009 at 02:21:44PM +0200, Michael Weissenbacher wrote:
>> Hi XFS-List!
>> I understand that the inode64 mount option allows inodes to be  
>> created beyond 1TB. There are also certain performance problems  
>> that can be cured by using this option when handling LOTS of  
>> inodes. During my tests i noticed that enabling it is like a one- 
>> way street. Inodes created with inode64 enabled aren't accessible  
>> when the option is left out.
>
> Actually they should still be accessible, we just won't create new
> inodes not addressable by 32bit inode numbers.

The inodes are indeed accessible by most apps, but those 32bit
apps using stat() (vs. stat64() ) will get confused and
may bailout processing such inodes all together.

>> Now i got a few questions:
>> - Does the inode64 option work only on 64bit architectures or is it  
>> also possible to use it with i686
>
> It is available for 32bit kernels starting with kernel 2.6.29.
>
>> - Is there a way to convert the inodes back
>
> There's an xfs_reno tool ported from IRIX to renumber the inodes.   
> I'll
> see if I can finally get it packaged.
>
>> - Why doesn't the filesystem remember that inode64 was used in the  
>> past and enable it automatically
>
> Good question.  We could introduce a flag in the superblock for this.

Agree, it's a good idea to record that inode64 was used on
previous mount, but I don't think we should enable it
automatically. Though, providing the warning will be good.

Felix

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
