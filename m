Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:49836 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753144AbeCEWGj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 5 Mar 2018 17:06:39 -0500
Subject: Re: [PATCH] fsck.xfs: allow forced repairs using xfs_repair
References: <20180305150546.32191-1-jtulak@redhat.com>
 <20180305215659.GE18129@dastard>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <2d50aa97-a03b-128f-f4f6-4a6416fac69b@sandeen.net>
Date: Mon, 5 Mar 2018 16:06:38 -0600
MIME-Version: 1.0
In-Reply-To: <20180305215659.GE18129@dastard>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>, Jan Tulak <jtulak@redhat.com>
Cc: linux-xfs@vger.kernel.org

On 3/5/18 3:56 PM, Dave Chinner wrote:
> On Mon, Mar 05, 2018 at 04:05:46PM +0100, Jan Tulak wrote:
>> The fsck.xfs script did nothing, because xfs doesn't need a fsck to be
>> run on every unclean shutdown. However, sometimes it may happen that the
>> root filesystem really requires the usage of xfs_repair and then it is a
>> hassle. This patch makes the situation a bit easier by detecting forced
>> checks (/forcefsck or fsck.mode=force), so user can require the repair,
>> without the repair being run all the time.
>>
>> (Thanks Eric for suggesting this.)
>>
>> Signed-off-by: Jan Tulak <jtulak@redhat.com>
> 
> Ok, so I can see why support for this is probably neecssary, I have
> a few reservations about the implementation....
> 
>> ---
>>  fsck/xfs_fsck.sh | 14 ++++++++++++--
>>  1 file changed, 12 insertions(+), 2 deletions(-)
>>
>> diff --git a/fsck/xfs_fsck.sh b/fsck/xfs_fsck.sh
>> index e52969e4..71bfa2e1 100755
>> --- a/fsck/xfs_fsck.sh
>> +++ b/fsck/xfs_fsck.sh
>> @@ -4,10 +4,12 @@
>>  #
>>  
>>  AUTO=false
>> -while getopts ":aApy" c
>> +FORCE=false
>> +while getopts ":aApyf" c
>>  do
>>  	case $c in
>>  	a|A|p|y)	AUTO=true;;
>> +	f)      	FORCE=true;;
>>  	esac
>>  done
>>  eval DEV=\${$#}
>> @@ -15,10 +17,18 @@ if [ ! -e $DEV ]; then
>>  	echo "$0: $DEV does not exist"
>>  	exit 8
>>  fi
>> +
>> +# The flag -f is added by systemd/init scripts when /forcefsck file is present
>> +# or fsck.mode=force is used during boot; an unclean shutdown won't trigger
>> +# this check, user has to explicitly require a forced fsck.
>> +if $FORCE; then
>> +	xfs_repair $DEV
>> +	exit $?
>> +fi
> 
> This needs to check that the xfs_repair binary is present in the
> environment that is running fsck. If this is checking the root fs
> from the initramfs, then distros are going to need to package
> xfs_repair into their initramfs build scripts...

Fedora and RHEL does, FWIW.  Can others check?  What does Debian do?

> Also, if the log is dirty, xfs_repair won't run. If the filesystem
> is already mounted read-only, xfs_repair won't run. So if we're
> forcing a boot time check, we want it to run unconditionally and fix
> any problems found automatically, right?

Yep, I'm curious if this was tested - I played with something like this
a while ago but didn't take notes.  ;)

As for running automatically and fix any problems, we may need to make
a decision.  If it won't mount due to a log problem, do we automatically
use -L or drop to a shell and punt to the admin?  (That's what we would
do w/o any fsck -f invocation today...)

> Also, fsck exit values have specific meaning to the boot
> infrastructure and xfs_repair does not follow them. Hence returning
> the output of xfs_repair to the fsck caller is going to result in
> unexpected/undesired behaviour. From the fsck man page:
> 
>       The exit code returned by fsck is the sum of the following conditions:
> 
>               0      No errors
>               1      Filesystem errors corrected
>               2      System should be rebooted
>               4      Filesystem errors left uncorrected
>               8      Operational error
>               16     Usage or syntax error
>               32     Checking canceled by user request
>               128    Shared-library error
> 
> So there's error post processing that is needed here so that the
> infrastructure is given the correct status indication so it will
> do things like reboot the system if necessary after a repair...

Good point, thanks.
 
> I also wonder if we can limit this to just the boot infrastructure,
> because I really don't like the idea of users using fsck.xfs -f to
> repair damage filesystems because "that's what I do to repair ext4
> filesystems"....

Depending on how this gets fleshed out, fsck.xfs -f isn't any different
than bare xfs_repair...  (Unless all of the above suggestions about dirty
logs get added, then it certainly is!)  So, yeah...

How would you propose limiting it to the boot environment?  I wondered
about the script itself checking for /forcefsck or the boot parameters,
but at least the boot params probably last for the duration of the uptime.
And re-coding / re-implementing the systemd checks in our own script
probably is a bad idea, so forget I suggested it ...

> Also missing is a fsck.xfs man page update to document the option.

*nod*

 
>>  if $AUTO; then
>>  	echo "$0: XFS file system."
>>  else
>>  	echo "If you wish to check the consistency of an XFS filesystem or"
>>  	echo "repair a damaged filesystem, see xfs_repair(8)."
>>  fi
>> -exit 0
> 
> I think we still need to exit with a zero status if we did nothing,
> because that's what the caller is expecting....
> 
> Cheers,
> 
> Dave.
> 
