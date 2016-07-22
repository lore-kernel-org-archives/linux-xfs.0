Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 658417CA0
	for <xfs@oss.sgi.com>; Fri, 22 Jul 2016 03:58:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1BCE330404E
	for <xfs@oss.sgi.com>; Fri, 22 Jul 2016 01:58:13 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id DCJQ1uZj5TtgD90O (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 22 Jul 2016 01:58:09 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id 2E74146213
	for <xfs@oss.sgi.com>; Fri, 22 Jul 2016 08:58:09 +0000 (UTC)
Date: Fri, 22 Jul 2016 10:58:04 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] xfs: Document error handling behavior
Message-ID: <20160722085804.GA2990@redhat.com>
References: <1468922657-3895-1-git-send-email-cmaiolino@redhat.com>
	<20160722040955.GB16413@zlang.usersys.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160722040955.GB16413@zlang.usersys.redhat.com>
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
To: Zorro Lang <zlang@redhat.com>
Cc: xfs@oss.sgi.com

On Fri, Jul 22, 2016 at 12:09:55PM +0800, Zorro Lang wrote:
> On Tue, Jul 19, 2016 at 12:04:17PM +0200, Carlos Maiolino wrote:
> > This is the first try to document the implementation of error handlers into
> > sysfs.
> > 
> > Reviews and comments are appreciated, please also notice I'm not english-native,
> > so, spelling corrections are also appreciated :)
> > 
> > Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> > ---
> >  Documentation/filesystems/xfs.txt | 78 +++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 78 insertions(+)
> > 
> > diff --git a/Documentation/filesystems/xfs.txt b/Documentation/filesystems/xfs.txt
> > index 8146e9f..1df868a 100644
> > --- a/Documentation/filesystems/xfs.txt
> > +++ b/Documentation/filesystems/xfs.txt
> > @@ -348,3 +348,81 @@ Removed Sysctls
> >    ----				-------
> >    fs.xfs.xfsbufd_centisec	v4.0
> >    fs.xfs.age_buffer_centisecs	v4.0
> > +
> > +Error handling
> > +==============
> > +
> > +XFS can act differently according with the type of error found
> > +during its operation. The implementation introduces the following
> > +concepts to the error handler:
> > +
> > + -failure speed:
> > +	Defines how fast XFS should shutdown in case of a specific
> > +	error is found during the filesystem  operation. It can
> > +	shutdown immediately, after a defined number of tries, or
> > +	simply try forever, which was the old behavior and is now
> > +	set as default behavior, except during unmount time, where
> > +	in case of a error is found while unmounting, the filesystem
> > +	will shutdown.
> > +
> > + -error classes:
> > +	Specifies the subsystem/location where the error handlers
> > +	configure the behavior for, such as metadata or memory allocation.
> > +
> > + -error handlers:
> > +	Defines the behavior for a specific error.
> > +
> > +The filesystem behavior during an error can be set via sysfs files, where, the
> > +errors are organized with the following structure:
> > +
> > +  /sys/fs/xfs/<dev>/error/<class>/<error>/
> > +
> > +Each directory contains:
> > +
> > + /sys/fs/xfs/<dev>/error/
> > +
> > +	fail_at_unmount		(Min:  0  Default:  1  Max: 1)
> > +		Defines the global error behavior during unmount time. If set to
> > +		"1", XFS will shutdown in case of any error is found, otherwise,
> > +		if set to "0", the filesystem will indefinitely retry to cleanly
> > +		unmount the filesystem.
> 
> Hi Carlos,
> 
> Could you explain more about the relationship of fail_at_unmount and
> max_retries(/retry_timeout_seconds). For example, if I set fail_at_unmount=0,
> and set EIO/max_retries=1, what's expected?
> 

They are different options, if max_retries is set to 1, it will fail
after the first try as expected, even if during unmount, and even if
fail_at_unmount = 0.

The problem, and the reason for us to have added fail_at_unmount, is that, you
can't change any configuration after umount is issued, because the sysfs
directory for the device being unmounted will be detached from sysfs, so, if the
sysadmin wants to make XFS retry forever for any error during the filesystem
operation, he is still able to unmount the filesystem "properly" (since, if the
FS find errors, it might not be a clean mount) if he sets fail_at_unmount,
otherwise, he might have umount process stuck forever.


> I'd like to write test case about this error handling, according to
> your document.
> 
> Thanks,
> Zorro
> 
> > +
> > +	<class> subdirectories
> > +		Contains specific error handlers configuration
> > +		(Ex: /sys/fs/xfs/<dev>/error/metadata).
> > +
> > + /sys/fs/xfs/<dev>/error/<class>/
> > +
> > +	The contents of this directory are <class> specific, since each <class>
> > +	might need to handle different types of errors. All <error> directory
> > +	though, contains the "default" directory, which is a global configuration
> > +	for errors not available for independent configuration.
> > +
> > + /sys/fs/xfs/<dev>/error/<class>/<error>
> > +
> > +	Contains the failure speed configuration files for each specific error,
> > +	including the "default" behavior, which contains the same configuration
> > +	options as the specific errors.
> > +
> > +	The available configurations for each error type are:
> > +
> > +	max_retries			(Min: -1  Default: -1  Max: INTMAX)
> > +		Define how many tries the filesystem is allowed to retry its
> > +		operations during the specific error, before shutdown the
> > +		filesystem. Setting this file to "-1", will set XFS to retry
> > +		forever in the specific error, setting it to "0", will make
> > +		XFS to fail immediately after the specific error is found,
> > +		while setting it to a "N" value, where N is greater than 0,
> > +		will make XFS retry "N" times before shutdown.
> > +
> > +	retry_timeout_seconds		(Min:  0  Default:  0  Max: INTMAX)
> > +		Define the amount of time (in seconds) that the filesystem is
> > +		allowed to retry its operations when the specific error is
> > +		found. "0" means no wait time.
> > +
> > +
> > +	"max_retries" takes precedence over "retry_timeout_seconds", where,
> > +	"retry_timeout_seconds" will only be tested if the "max_retries" limit
> > +	were not reached yet or is set to retry forever ("-1"). If "max_retries"
> > +	limit is reached, the filesystem will shutdown, wether or not
> > +	"retry_timeout_seconds" has been reached.
> > -- 
> > 2.7.4
> > 
> > _______________________________________________
> > xfs mailing list
> > xfs@oss.sgi.com
> > http://oss.sgi.com/mailman/listinfo/xfs

-- 
Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
