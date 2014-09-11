Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 723E37F6D
	for <xfs@oss.sgi.com>; Thu, 11 Sep 2014 00:48:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 60042304043
	for <xfs@oss.sgi.com>; Wed, 10 Sep 2014 22:48:42 -0700 (PDT)
Received: from mail04.lsn.net (mail04.lsn.net [66.90.130.138]) by cuda.sgi.com
	with ESMTP id y7kOGmzUMoJvtGZu for <xfs@oss.sgi.com>;
	Wed, 10 Sep 2014 22:48:40 -0700 (PDT)
Message-ID: <54113773.2090103@mygrande.net>
Date: Thu, 11 Sep 2014 00:47:31 -0500
From: Leslie Rhorer <lrhorer@mygrande.net>
MIME-Version: 1.0
Subject: Re: Corrupted files
References: <540F1B01.3020700@mygrande.net> <20140909220645.GH20518@dastard>
	<540FA586.9090308@mygrande.net> <20140910015331.GJ20518@dastard>
	<540FC135.8010601@mygrande.net> <20140910033331.GA27048@dastard>
	<540FD8DE.7090306@mygrande.net> <20140910052303.GB27048@dastard>
In-Reply-To: <20140910052303.GB27048@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 9/10/2014 12:23 AM, Dave Chinner wrote:
> On Tue, Sep 09, 2014 at 11:51:42PM -0500, Leslie Rhorer wrote:
>> On 9/9/2014 10:33 PM, Dave Chinner wrote:
>>> On Tue, Sep 09, 2014 at 10:10:45PM -0500, Leslie Rhorer wrote:
>>>> On 9/9/2014 8:53 PM, Dave Chinner wrote:
>>>>> On Tue, Sep 09, 2014 at 08:12:38PM -0500, Leslie Rhorer wrote:
>>>>>> On 9/9/2014 5:06 PM, Dave Chinner wrote:
>>>> 	I've never used git on a package maintained in my distro.  Will I
>>>> have issues when I upgrade to Debian Jessie in a few months, since
>>>> this is not being managed by apt / dpkg?  It looks like Jessie has
>>>> 3.2.1 of xfs-progs.
>>>
>>> If you're using debian you can build debian packages directly from
>>> the git tree via "make deb" (I use it all the time for pushing
>>> new builds to my test machines) and so when you upgrade to Jessie it
>>> should just replace your custom built package correctly...
>>
>> 	Thanks a ton, Dave (and everyone else who helped).  That seems to
>> have worked just fine.  The three grunged entries are gone and the
>> system is happily copying over the backups.  Now I'll run another
>> rsync with checksum to make sure everything is good before putting
>> the backup into production.  I'm also going to upgrade the
>> controller BIOS just in case.
>
> Good to hear. Hopefully everything will check out. Just yell if you
> need more help. ;)

	Thanks.  The rsync compare just finished on the non-volatile areas of 
the file system without a single mismatch and no missing files.  That's 
good enough for me.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
