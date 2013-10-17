Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 426B67F3F
	for <xfs@oss.sgi.com>; Thu, 17 Oct 2013 05:49:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 25DA78F8054
	for <xfs@oss.sgi.com>; Thu, 17 Oct 2013 03:49:16 -0700 (PDT)
Date: Thu, 17 Oct 2013 12:49:10 +0200 (CEST)
From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 10/10 v2] xfstests: Remount file system if MOUNT_OPTIONS
	changedx
In-Reply-To: <525EFC49.7090300@sgi.com>
Message-ID: <alpine.LFD.2.00.1310171248010.3490@localhost.localdomain>
References: <1373539085-8577-1-git-send-email-lczerner@redhat.com>
	<1373539085-8577-11-git-send-email-lczerner@redhat.com>
	<525EFC49.7090300@sgi.com>
MIME-Version: 1.0
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
To: Rich Johnston <rjohnston@sgi.com>
Cc: xfs@oss.sgi.com

On Wed, 16 Oct 2013, Rich Johnston wrote:

> Date: Wed, 16 Oct 2013 15:51:21 -0500
> From: Rich Johnston <rjohnston@sgi.com>
> To: Lukas Czerner <lczerner@redhat.com>, xfs@oss.sgi.com
> Subject: Re: [PATCH 10/10 v2] xfstests: Remount file system if MOUNT_OPTIONS
>     changed
> 
> Hi Lukas,
> 
> On 07/11/2013 05:38 AM, Lukas Czerner wrote:
> > When MOUNT_OPTIONS change we should remount TEST_DEV to put the changes
> > in effect. This will allow us to have different MOUNT_OPTIONS in sections
> > in configuration file.
> > 
> > Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> > ---
> >   README.config-sections | 8 ++++++++
> >   check                  | 8 ++++++++
> >   2 files changed, 16 insertions(+)
> > 
> > diff --git a/README.config-sections b/README.config-sections
> > index 4d60272..2849fd5 100644
> > --- a/README.config-sections
> > +++ b/README.config-sections
> > @@ -36,6 +36,14 @@ For every section xfstests will run with specified
> > options and will produce
> >   separate results in the '$RESULT_BASE/$section_name' directory.
> > 
> > 
> > +Different mount options
> > +-----------------------
> > +
> > +Specifying different mount options in difference config sections is
> > allowed.
> > +When MOUNT_OPTIONS differs in the following section TEST_DEV will be
> > remounted
> > +with new MOUNT_OPTIONS automatically before running the test.
> > +
> > +
> >   Multiple file systems
> >   ---------------------
> > 
> > diff --git a/check b/check
> > index 5775276..ef91260 100755
> > --- a/check
> > +++ b/check
> > @@ -394,6 +394,7 @@ fi
> > 
> >   for section in $HOST_OPTIONS_SECTIONS; do
> >   	OLD_FSTYP=$FSTYP
> > +	OLD_MOUNT_OPTIONS=$MOUNT_OPTIONS
> >   	get_next_config $section
> > 
> >   	mkdir -p $RESULT_BASE
> > @@ -422,6 +423,13 @@ for section in $HOST_OPTIONS_SECTIONS; do
> >   			exit 1
> >   		fi
> >   		_prepare_test_list
> > +	elif [ "$OLD_MOUNT_OPTIONS" != "$MOUNT_OPTIONS" ]; then
> > +		_umount_or_remount_ro $TEST_DEV 2>&1> /dev/null
> > +		out=`_mount_or_remount_rw "$MOUNT_OPTIONS" $TEST_DEV
> > $TEST_DIR`
> > +		if [ $? -ne 1 ]; then
> > +			echo $out
> > +			exit 1
> > +		fi
> >   	fi
> > 
> >   	init_rc
> > 
> 
> Sorry this took so long to get to but this no longer applies cleanly.

Yeah, it has been a long time. I planned to rebase and resend,
however I have not had a time to do so. But hopefully I'll be able
to get to it at some point.

Thanks!
-Lukas

> 
> Thanks
> --Rich
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
