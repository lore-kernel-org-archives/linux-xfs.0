Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 38D0329DF8
	for <xfs@oss.sgi.com>; Thu,  2 May 2013 12:44:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id F0D5E8F8039
	for <xfs@oss.sgi.com>; Thu,  2 May 2013 10:44:25 -0700 (PDT)
Received: from e39.co.us.ibm.com (e39.co.us.ibm.com [32.97.110.160]) by
	cuda.sgi.com with ESMTP id ACeHjgQtMKwS0GsM (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 02 May 2013 10:44:24 -0700 (PDT)
Received: from /spool/local
	by e39.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Thu, 2 May 2013 11:44:23 -0600
Received: from d01relay06.pok.ibm.com (d01relay06.pok.ibm.com [9.56.227.116])
	by d01dlp03.pok.ibm.com (Postfix) with ESMTP id 05E92C90048
	for <xfs@oss.sgi.com>; Thu,  2 May 2013 13:44:20 -0400 (EDT)
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay06.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r42HiKRQ39518324
	for <xfs@oss.sgi.com>; Thu, 2 May 2013 13:44:20 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	r42HiJQC009226 for <xfs@oss.sgi.com>; Thu, 2 May 2013 14:44:19 -0300
Subject: Re: [PATCH] xfstests: fix internal _xfs_check to handle logdev etc
From: Chandra Seetharaman <sekharan@us.ibm.com>
In-Reply-To: <51828F84.3040508@sandeen.net>
References: <51827DDF.4050708@redhat.com>
	<1367509132.4098.86.camel@chandra-dt.ibm.com>
	<51828F84.3040508@sandeen.net>
Date: Thu, 02 May 2013 12:44:18 -0500
Message-ID: <1367516658.4098.87.camel@chandra-dt.ibm.com>
Mime-Version: 1.0
Reply-To: sekharan@us.ibm.com
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, "Michael L. Semon" <mlsemon35@gmail.com>, xfs-oss <xfs@oss.sgi.com>

On Thu, 2013-05-02 at 11:08 -0500, Eric Sandeen wrote:
> On 5/2/13 10:38 AM, Chandra Seetharaman wrote:
> > On Thu, 2013-05-02 at 09:53 -0500, Eric Sandeen wrote:
> >> Pull all of the old xfs_check script into common/rc:_xfs_check()
> >> so that it properly handles all options, including external log
> >> devices.
> > 
> > I see changes only related to USAGE. iiuc, log devices are handled
> > properly by current code.
> 
> also:
> 
> >> +    set -- extra $@
> >> +    shift $OPTIND
> 
> have you *tested* log devices w/ your original code?  It failed for
> Michael and for myself, so...  ;)
> 
> -Eric

yikes. sorry :(
> 
> >>
> >> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> >> ---
> >>
> >> diff --git a/common/rc b/common/rc
> >> index 19a0e18..b47a53e 100644
> >> --- a/common/rc
> >> +++ b/common/rc
> >> @@ -393,8 +393,8 @@ _xfs_check()
> >>  {
> >>      OPTS=" "
> >>      DBOPTS=" "
> >> +    USAGE="Usage: xfs_check [-fsvV] [-l logdev] [-i ino]... [-b bno]... special"
> >>
> >> -    OPTIND=1
> >>      while getopts "b:fi:l:stvV" c
> >>      do
> >>          case $c in
> >> @@ -410,8 +410,17 @@ _xfs_check()
> >>                  ;;
> >>          esac
> >>      done
> >> -    ${XFS_DB_PROG}${DBOPTS} -F -i -p xfs_check -c "check$OPTS" $1
> >> -    return $?
> >> +    set -- extra $@
> >> +    shift $OPTIND
> >> +    case $# in
> >> +        1)    ${XFS_DB_PROG}${DBOPTS} -F -i -p xfs_check -c "check$OPTS" $1
> >> +               status=$?
> >> +               ;;
> >> +        2)    echo $USAGE 1>&1
> >> +              status=2
> >> +              ;;
> >> +    esac
> >> +    return $status
> >>  }
> >>
> >>  _setup_large_ext4_fs()
> >>
> >>
> >>
> > 
> > 
> > _______________________________________________
> > xfs mailing list
> > xfs@oss.sgi.com
> > http://oss.sgi.com/mailman/listinfo/xfs
> > 
> 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
