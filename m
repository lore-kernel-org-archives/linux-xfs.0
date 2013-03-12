Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5CA127F51
	for <xfs@oss.sgi.com>; Tue, 12 Mar 2013 17:16:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id DDA2CAC006
	for <xfs@oss.sgi.com>; Tue, 12 Mar 2013 15:16:23 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id xBCMo2BEBzN6eSCW
	for <xfs@oss.sgi.com>; Tue, 12 Mar 2013 15:16:23 -0700 (PDT)
Message-ID: <513FA938.6080603@hardwarefreak.com>
Date: Tue, 12 Mar 2013 17:16:24 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: XFS filesystem corruption
References: <CAPcwv6wZJSBtgF-L6KNSn6N6Y+wUZJFXdbcg+zYRwoaB2sDdjw@mail.gmail.com>
	<5137CD46.6070909@redhat.com> <5139A3B6.3040805@hardwarefreak.com>
	(sfid-20130308_132012_037479_915CAB49)
	<201303121142.13980.Martin@lichtvoll.de>
In-Reply-To: <201303121142.13980.Martin@lichtvoll.de>
Reply-To: stan@hardwarefreak.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: Julien FERRERO <jferrero06@gmail.com>, Ric Wheeler <rwheeler@redhat.com>, xfs@oss.sgi.com

On 3/12/2013 5:42 AM, Martin Steigerwald wrote:
> Am Freitag, 8. M=E4rz 2013 schrieb Stan Hoeppner:
>> If the techs are determined to hard cut power because they don't have
>> the time or the knowledge to do a clean shutdown, it may be well worth
>> your time/effort to write a script and teach the field techs to execute
>> it, before flipping the master switch.  Your simple script would run as
>> root, or you'd need to do some sudo foo within, and would contain
>> something like:
>>
>> #! /bin/sh
>> sync
>> echo 2 > /proc/sys/vm/drop_caches
>> echo "Ready for power down."
> =

> mount -o remount,ro /your/mount/point
> =

> One can at least try. Maybe some "service stop" commands before that.
> =

> But then, if using a script like this, why not just type "halt"?
...

The real solution to the OP's problem has nothing to do with XFS, buffer
flushing, nor Linux shutdown modes.  The problem is power and automation
of cutting power.  And the solution is rather simple.

Put a small UPS in the van backing the server, connect USB or serial,
and configure upsmon.  When the crews hit the master switch, AC to the
UPS is lost, and upsmon then performs a clean shutdown of the server.
The crews do nothing more than they currently do.  And they don't have
to wait on anything.  If the previously described "master" switch *is*
currently a UPS, simply install another smaller unit inline to the
server.  Disable the audible alarm on the small unit as by default it
will screech continuously while AC input is absent.  At the end of the
day they simply flip the switch on this little UPS so it's not running
overnight/weekends (though with no load it probably wouldn't drain the
battery--this just a safety precaution).  At the start of the next day,
they flip the master switch, then the little UPS switch.

I've not laid eyes on the vans/power circuits/gear in question so I'm
making educated guesses.  There may be even better/easier ways to do it.
 But one way or another, a properly configured UPS/upsmon setup is the
way to go, if the desire is to easily control everything with power
switches.

-- =

Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
