Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7B9jZrK131847
	for <linux-xfs@oss.sgi.com>; Wed, 11 Aug 2010 04:45:36 -0500
Received: from lo.gmane.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C186E1D72008
	for <linux-xfs@oss.sgi.com>; Wed, 11 Aug 2010 02:45:59 -0700 (PDT)
Received: from lo.gmane.org (lo.gmane.org [80.91.229.12]) by cuda.sgi.com with
	ESMTP id hVkymNpTFoAMAbEx for <linux-xfs@oss.sgi.com>;
	Wed, 11 Aug 2010 02:45:59 -0700 (PDT)
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <sgi-linux-xfs@m.gmane.org>) id 1Oj7sh-0006aR-BV
	for linux-xfs@oss.sgi.com; Wed, 11 Aug 2010 11:45:55 +0200
Received: from barriere.frankfurter-softwarefabrik.de ([217.11.197.1])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Wed, 11 Aug 2010 11:45:55 +0200
Received: from niemayer by barriere.frankfurter-softwarefabrik.de with local
	(Gmexim 0.1 (Debian)) id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Wed, 11 Aug 2010 11:45:55 +0200
From: Peter Niemayer <niemayer@isg.de>
Subject: Re: observed significant performance improvement using "delaylog"
	in a real-world application
Date: Wed, 11 Aug 2010 11:45:41 +0200
Message-ID: <i3trg6$eps$1@dough.gmane.org>
References: <i3rt4t$46c$1@dough.gmane.org> <201008111003.36890@zmi.at>
Mime-Version: 1.0
In-Reply-To: <201008111003.36890@zmi.at>
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

On 08/11/2010 10:03 AM, Michael Monnerie wrote:
> On Dienstag, 10. August 2010 Peter Niemayer wrote:
>> 17% performance increase for our benchmark scenario
>
> Can you say what kind of data accesses you have?

The application basically writes a large data set to ~ 100,000 files,
which consists of many small messages. Each message consists of a 
primary key (an integer in the range of 0 to approx. 1,000,000) and
an (almost random) number of data bytes (length in the range from 10 to
~1000 byte).

For each message, the application opens the file that is determined by
the primary key with O_APPEND, write()s the data bytes to the file.
Then it closes the file. (There are usually a few to many messages per
primary key / file).
The application runs 4 threads in parallel to spread the above action
over 4 CPU cores, each thread processes a quarter of the primary keys
(primary_key & 0x03).

This description is, of course, somewhat simplified, but it should
get you an idea on the kind of I/O-operations.

Regards,

Peter Niemayer


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
