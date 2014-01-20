Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3B26B7F37
	for <xfs@oss.sgi.com>; Mon, 20 Jan 2014 12:19:08 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1BFFF304039
	for <xfs@oss.sgi.com>; Mon, 20 Jan 2014 10:19:05 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id ddppvZA4kikvQtY7 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 20 Jan 2014 10:19:02 -0800 (PST)
Date: Mon, 20 Jan 2014 19:19:01 +0100
From: David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH 2/5] xfstests: use value of FSTYP if defined externally
Message-ID: <20140120181901.GZ6498@suse.cz>
References: <cover.1389891730.git.dsterba@suse.cz>
	<efafb76f725148435b09a22c62c92a63eedb9b71.1389891730.git.dsterba@suse.cz>
	<20140120021345.GG18112@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140120021345.GG18112@dastard>
Reply-To: dsterba@suse.cz
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Mon, Jan 20, 2014 at 01:13:45PM +1100, Dave Chinner wrote:
> On Thu, Jan 16, 2014 at 06:07:12PM +0100, David Sterba wrote:
> > --- a/check
> > +++ b/check
> > @@ -33,7 +33,7 @@ showme=false
> >  have_test_arg=false
> >  randomize=false
> >  here=`pwd`
> > -FSTYP=xfs
> > +FSTYP=${FSTYP:-xfs}
> 
> ":-xfs" means assign the value of $xfs if $FTYPE is null. xfs is not
> a variable....

Docs say that

  ${parameter:-word}
  If parameter is unset or null, the expansion of word is substituted.
  Otherwise, the value of parameter is substituted.

so 'xfs' will expand to itself.  And I did test this one with:

$ cat default.sh << EOF
FSTYP=${FSTYP:-xfs}
echo $FSTYP
EOF

$ cat external.sh << EOF
FSTYP=btrfs
source default.sh
EOF

$ sh default.sh
xfs

$ sh external.sh
btrfs

> > -# Autodetect fs type based on what's on $TEST_DEV
> > -if [ "$HOSTOS" == "Linux" ]; then
> > +# Autodetect fs type based on what's on $TEST_DEV unless it's been set
> > +# externally
> > +if [ -z "$FSTYP" -a "$HOSTOS" == "Linux" ]; then
> 
> If the default value expansion is fixed, FSTYP will always have a
> value here Hence it will never, ever probe.

> >      FSTYP=`blkid -c /dev/null -s TYPE -o value $TEST_DEV`
> >  fi
> >  export FSTYP
> 
> I suspect what you want is:
> 
> -FSTYP=xfs
> 
> .....
> 
> if [ -z "$FSTYP" -a "$HOSTOS" == "Linux" ]; then
>      FSTYP=`blkid -c /dev/null -s TYPE -o value $TEST_DEV`
> fi
> FSTYP=${FSTYP:=xfs}
> export FSTYP

Right, the default assignment has to be last. I'll use the := form
to be consistent with what's used in the file, though :- works here as
well, just does not assign the variable within the ${...} expression.
The result is the same.


thanks,
david

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
