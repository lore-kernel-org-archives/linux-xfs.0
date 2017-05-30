Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:37432 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750821AbdE3S4m (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 30 May 2017 14:56:42 -0400
Subject: Re: [PATCH 7/9] xfs_spaceman: Free space mapping command
References: <149417257252.24656.2629280196308754994.stgit@birch.djwong.org>
 <149417262028.24656.18212282685789184986.stgit@birch.djwong.org>
 <183c279a-61c8-f0bd-64da-d7d0e99f2a6d@sandeen.net>
 <20170530184041.GA4519@birch.djwong.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <d2defe9d-643e-109c-e070-c25c79f5d6fe@sandeen.net>
Date: Tue, 30 May 2017 13:56:39 -0500
MIME-Version: 1.0
In-Reply-To: <20170530184041.GA4519@birch.djwong.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: sandeen@redhat.com, linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>

On 5/30/17 1:40 PM, Darrick J. Wong wrote:
> On Fri, May 26, 2017 at 08:57:14PM -0500, Eric Sandeen wrote:
>>
>>
>> On 5/7/17 10:57 AM, Darrick J. Wong wrote:
>>> From: Dave Chinner <dchinner@redhat.com>
>>>
>>> Add freespace mapping tool modelled on the xfs_db freesp command.
>>> The advantage of this command over xfs_db is that it can be done
>>> online and is coherent with concurrent modifications to the
>>> filesystem.
>>>
>>> This requires the kernel to support the XFS_IOC_GETFSMAP ioctl to map
>>> free space indexes.
>>>
>>> Signed-off-by: Dave Chinner <dchinner@redhat.com>
>>> [darrick: port from FIEMAPFS to GETFSMAP]
>>> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
>>> ---
>>>  spaceman/Makefile   |   12 +-
>>>  spaceman/ag.c       |    1 
>>>  spaceman/file.c     |   18 ++-
>>>  spaceman/freesp.c   |  367 +++++++++++++++++++++++++++++++++++++++++++++++++++
>>>  spaceman/init.c     |    9 +
>>>  spaceman/prealloc.c |    1 
>>>  spaceman/space.h    |   12 +-
>>>  spaceman/trim.c     |    1 
>>>  8 files changed, 413 insertions(+), 8 deletions(-)
>>>  create mode 100644 spaceman/freesp.c
>>>
>>>
>>> diff --git a/spaceman/Makefile b/spaceman/Makefile
>>> index 08709b3..3b059ca 100644
>>> --- a/spaceman/Makefile
>>> +++ b/spaceman/Makefile
>>> @@ -7,8 +7,12 @@ include $(TOPDIR)/include/builddefs
>>>  
>>>  LTCOMMAND = xfs_spaceman
>>>  HFILES = init.h space.h
>>> -CFILES = init.c \
>>> -	ag.c file.c prealloc.c trim.c
>>> +CFILES = ag.c \
>>> +	 file.c \
>>> +	 init.c \
>>> +	 prealloc.c \
>>> +	 trim.c
>>> +
>>>  
>>>  LLDLIBS = $(LIBXCMD)
>>>  LTDEPENDENCIES = $(LIBXCMD)
>>> @@ -22,6 +26,10 @@ ifeq ($(ENABLE_EDITLINE),yes)
>>>  LLDLIBS += $(LIBEDITLINE) $(LIBTERMCAP)
>>>  endif
>>>  
>>> +ifeq ($(HAVE_GETFSMAP),yes)
>>> +CFILES += freesp.c
>>> +endif
>>> +
>>>  default: depend $(LTCOMMAND)
>>>  
>>>  include $(BUILDRULES)
>>> diff --git a/spaceman/ag.c b/spaceman/ag.c
>>> index 1eb8aa0..0f1c869 100644
>>> --- a/spaceman/ag.c
>>> +++ b/spaceman/ag.c
>>> @@ -21,6 +21,7 @@
>>>  #include "command.h"
>>>  #include "input.h"
>>>  #include "init.h"
>>> +#include "path.h"
>>>  #include "space.h"
>>>  
>>>  #ifndef XFS_IOC_AGCONTROL
>>> diff --git a/spaceman/file.c b/spaceman/file.c
>>> index 9356066..7c5ea0e 100644
>>> --- a/spaceman/file.c
>>> +++ b/spaceman/file.c
>>> @@ -22,6 +22,7 @@
>>>  #include "command.h"
>>>  #include "input.h"
>>>  #include "init.h"
>>> +#include "path.h"
>>>  #include "space.h"
>>>  
>>>  static cmdinfo_t print_cmd;
>>> @@ -69,8 +70,10 @@ openfile(
>>>  	char		*path,
>>>  	xfs_fsop_geom_t	*geom,
>>>  	int		flags,
>>> -	mode_t		mode)
>>> +	mode_t		mode,
>>> +	struct fs_path	*fs_path)
>>>  {
>>> +	struct fs_path	*fsp;
>>>  	int		fd;
>>>  
>>>  	fd = open(path, flags, mode);
>>> @@ -95,6 +98,15 @@ openfile(
>>>  		close(fd);
>>>  		return -1;
>>>  	}
>>> +
>>> +	if (fs_path) {
>>> +		fsp = fs_table_lookup(path, FS_MOUNT_POINT);
>>> +		if (!fsp) {
>>> +			fprintf(stderr, _("Unable to find XFS information."));
>>
>> If I got that error I wouldn't know what it meant...
> 
> "Unable to find mount information." ?

I think that if the path isn't found in the table, that means it wasn't
populated on startup, which means it's not [on] an XFS filesystem:

        fs = fs_table_lookup(argv[optind], FS_MOUNT_POINT);
        if (!fs) {
                fprintf(stderr, _("%s: %s is not a mounted XFS filesystem\n"),
                        progname, argv[optind]);
                return 1;
        }

or

                fprintf(stderr, _("file argument, \"%s\", is not in a mounted XFS filesystem\n"),
                        file->name);

is what other tools do (although quota does:

                fprintf(stderr, "%s: unknown mount point %s\n", progname, dir);
or
                fprintf(stderr, "%s: cannot find mount point %s\n",)


Anyway: I think the failure means that the path is not [on] an xfs filesystem,
so that's probably the best information to convey.

-Eric
