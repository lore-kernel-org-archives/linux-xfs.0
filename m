Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7CLkX84252159
	for <linux-xfs@oss.sgi.com>; Thu, 12 Aug 2010 16:46:36 -0500
Received: from lo.gmane.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0299614CD663
	for <linux-xfs@oss.sgi.com>; Thu, 12 Aug 2010 14:55:43 -0700 (PDT)
Received: from lo.gmane.org (lo.gmane.org [80.91.229.12]) by cuda.sgi.com with
	ESMTP id RhLpHU5UHaHZAwnz for <linux-xfs@oss.sgi.com>;
	Thu, 12 Aug 2010 14:55:43 -0700 (PDT)
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <sgi-linux-xfs@m.gmane.org>) id 1Ojfbv-0007Xy-UW
	for linux-xfs@oss.sgi.com; Thu, 12 Aug 2010 23:46:51 +0200
Received: from barriere.frankfurter-softwarefabrik.de ([217.11.197.1])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Thu, 12 Aug 2010 23:46:51 +0200
Received: from niemayer by barriere.frankfurter-softwarefabrik.de with local
	(Gmexim 0.1 (Debian)) id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Thu, 12 Aug 2010 23:46:51 +0200
From: Peter Niemayer <niemayer@isg.de>
Subject: Re: observed significant performance improvement using "delaylog" in
Date: Thu, 12 Aug 2010 23:46:43 +0200
Message-ID: <i41q43$6td$1@dough.gmane.org>
References: <201008121346.30760.eye.of.the.8eholder@gmail.com>
	<201008122105.35787@zmi.at>
Mime-Version: 1.0
In-Reply-To: <201008122105.35787@zmi.at>
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
To: linux-xfs@oss.sgi.com

On 08/12/2010 09:05 PM, Michael Monnerie wrote:
> On Donnerstag, 12. August 2010 Khelben Blackstaff wrote:
>> Here is my post with the results of the benchmark.
>> http://lordkhelben.wordpress.com/2010/07/08/xfs-delayed-logging/
>
> Wow, BTRFS rocks.

Be sure to measure your specific use-case before jumping
to conclusions.

With our application, for example, Btrfs performed exceptionally
bad - about 4 times(!) as slow as XFS.

Then again, there are some use-cases where even older
file-systems like reiser3 excel (e.g. storing files for
cyrus imapd).


> But I'm stunned that XFS is that much slower than ext4 in many tests.

Again, it all depends on the use-case. For us, ext4
performs good (when used with all kinds of performance-enhancing,
safety-reducing mount-options), but not as good as XFS.

To me, as of today, XFS' big strength is performing good to
excellent (while not always better than all other file-systems)
in many use-cases - without worries about instability or immaturity.


One thing, I guess, is for sure: Every file-system will require
continued development to stay competitive.

SSDs, for example, are just beginning to get used appropriately
by modern file-systems. There's plenty of opportunity left to
optimize for them.

And once that is done, there may be yet another storage-technology
available (PRAM? Racetrack?), that benefits from specific strategies.

So the competition will stay open... :-)

Regards,

Peter Niemayer


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
