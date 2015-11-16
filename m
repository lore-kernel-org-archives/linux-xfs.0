Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9F5BC7F4E
	for <xfs@oss.sgi.com>; Mon, 16 Nov 2015 17:51:50 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8BDCA304039
	for <xfs@oss.sgi.com>; Mon, 16 Nov 2015 15:51:50 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id OjaGxsxsnk8eQaph (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 16 Nov 2015 15:51:48 -0800 (PST)
Date: Mon, 16 Nov 2015 15:51:11 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 01/12] test-scripts: test migration scripts
Message-ID: <20151116235111.GE2224@birch.djwong.org>
References: <20151113213643.31124.80975.stgit@birch.djwong.org>
	<20151113213650.31124.16817.stgit@birch.djwong.org>
	<20151116205845.GK14311@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151116205845.GK14311@dastard>
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
Cc: fstests@vger.kernel.org, xfs@oss.sgi.com, hch@infradead.org, tao.peng@primarydata.com, linux-ext4@vger.kernel.org, Anna.Schumaker@netapp.com, linux-btrfs@vger.kernel.org

On Tue, Nov 17, 2015 at 07:58:45AM +1100, Dave Chinner wrote:
> On Fri, Nov 13, 2015 at 01:36:50PM -0800, Darrick J. Wong wrote:
> > Add two scripts: "nextid" finds the next available test ID number in a
> > group, and "mvtest" relocates a test, fixes the golden output, and
> > moves the group entry for that test.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  mvtest |   58 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  nextid |   35 +++++++++++++++++++++++++++++++++++
> 
> These should be placed in the "tools" directory.

<nod>

> 
> >  create mode 100755 mvtest
> >  create mode 100755 nextid
> > 
> > 
> > diff --git a/mvtest b/mvtest
> > new file mode 100755
> > index 0000000..b5406d1
> > --- /dev/null
> > +++ b/mvtest
> > @@ -0,0 +1,58 @@
> > +#!/bin/sh
> > +
> > +# Renumber a test
> > +
> > +if [ -z "$1" ] || [ "$1" = "--help" ]; then
> > +	echo "Usage: $0 path_to_test new_path_to_test"
> > +	exit 1
> > +fi
> > +
> > +src="$1"
> > +dest="$2"
> > +
> > +die() {
> > +	echo "$@"
> > +	exit 1
> > +}
> > +
> > +nsort() {
> > +	sort -g < "$1" > "$2"
> > +}
> > +
> > +append() {
> > +	out="$1"
> > +	shift
> > +	echo "$@" >> "${out}"
> > +}
> > +
> > +test "${src}" != "${dest}" || die "Test \"${src}\" is the same as dest."
> > +test -e "tests/${src}" || die "Test \"${src}\" does not exist."
> > +test ! -e "tests/${dest}" || die "Test \"${src}\" already exists."
> > +
> > +sid="$(basename "${src}")"
> > +did="$(basename "${dest}")"
> > +
> > +sgroup="$(basename "$(dirname "tests/${src}")")"
> > +dgroup="$(basename "$(dirname "tests/${dest}")")"
> > +
> > +sgroupfile="tests/${sgroup}/group"
> > +dgroupfile="tests/${sgroup}/group"
> > +
> > +$DBG git mv "tests/${src}" "tests/${dest}"
> 
> $DBG?

"DBG=echo ./mvtest foo bar" to see what it would have run, more or less.

(I suppose I could getopt a --dry-run, but I could also just get rid of them.)

> 
> ....
> > +$DBG sed -e "/^${sid}.*$/d" -i "${sgroupfile}"
> > +$DBG cp "${dgroupfile}" "${dgroupfile}.new"
> > +$DBG append "${dgroupfile}.new" "${newgrpline}"
> > +$DBG nsort "${dgroupfile}.new" "${dgroupfile}"
> 
> What does this do to comments in the group file?

Eats them.  I don't know of a good way to sort just the uncommented lines
in the file, short of writing a python script to do that.

I guess it's not that hard; I've sort of needed one here and there over
the years, but never wrote one, and $google doesn't immediately provide
any such thing.

> 
> ...
> 
> > diff --git a/nextid b/nextid
> > new file mode 100755
> > index 0000000..285b549
> > --- /dev/null
> > +++ b/nextid
> > @@ -0,0 +1,35 @@
> > +#!/bin/sh
> > +
> > +# Given a group name, find the next available test number.
> > +
> > +if [ -z "$1" ] || [ "$1" = "--help" ]; then
> > +	echo "Usage: $0 groupname[/start_looking_at_this_number]"
> > +	exit 1
> > +fi
> > +
> > +die() {
> > +	echo "$@"
> > +	exit 1
> > +}
> > +
> > +if [ "$(basename "$1")" != "$1" ]; then
> > +	group="$(dirname "$1")"
> > +	id="$(basename "$1")"
> > +else
> > +	group="$1"
> > +	id=1
> > +fi
> > +test -e "tests/${group}/group" || die "Unknown group \"${group}\"."
> > +
> > +while test "${id}" -lt 1000; do
> > +	name="$(printf "%.03d" "${id}")"
> > +	if [ ! -e "tests/${group}/${name}" ]; then
> > +		echo "${group}/${name}"
> > +		exit 0
> > +	fi
> > +	id=$((id + 1))
> > +done
> > +
> > +echo "No free IDs less than ${id} in group \"${group}\"."
> 
> So the "new" script does this differently, by reading the group
> file and looking for the first non-contiguous ID in the file. It
> doesn't need scan ID limits because EOF triggers that. Wouldn't it
> be better to to factor the code out of the "new" script to find the
> next id, and then have the new script call that?

Sure!

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
