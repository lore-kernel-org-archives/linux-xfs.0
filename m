Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 174157F89
	for <xfs@oss.sgi.com>; Fri,  3 May 2013 14:26:04 -0500 (CDT)
Message-ID: <51840F54.9060206@sgi.com>
Date: Fri, 3 May 2013 14:26:12 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests 311: test fsync with dm flakey V3
References: <1367003639-17621-1-git-send-email-jbacik@fusionio.com>
	<51840047.4020908@sgi.com>
	<20130503190514.GD12414@localhost.localdomain>
In-Reply-To: <20130503190514.GD12414@localhost.localdomain>
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
To: Josef Bacik <jbacik@fusionio.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 05/03/2013 02:05 PM, Josef Bacik wrote:
> On Fri, May 03, 2013 at 12:21:59PM -0600, Rich Johnston wrote:
>> Thanks for another patch Josef, it has been committed with the change
>> discussed.
>>
>
> Err I forgot to point out I already have a "sync" variable in there so it fails
> to compile, we'll need to change the var to do_sync or something.  Want me to
> send a patch along?  Thanks,
>
> Josef
>
Sorry this was my fault, I have reverted


commit 7f622f44b651aec13b99ef62c2942388a6fbee5d
Author: Rich Johnston <rjohnston@sgi.com>
Date:   Fri May 3 14:07:59 2013 -0500

     Revert "xfstests 311: test fsync with dm flakey V3"

and committed it again.

commit dd3b5268312e0518ae695e8ee2a618f13805c425
Author: Josef Bacik <jbacik@fusionio.com>
Date:   Fri Apr 26 19:13:59 2013 +0000

     xfstests 311: test fsync with dm flakey V4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
