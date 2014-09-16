Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8B52D7F47
	for <xfs@oss.sgi.com>; Tue, 16 Sep 2014 16:42:51 -0500 (CDT)
Date: Tue, 16 Sep 2014 16:42:50 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [RFC] Unicode/UTF-8 support for XFS
Message-ID: <20140916214250.GU19952@sgi.com>
References: <20140911203735.GA19952@sgi.com> <20140912100230.GB4267@dastard>
	<5412DF37.9030005@sgi.com> <20140912205528.GB11717@infradead.org>
	<54169248.1090105@sgi.com> <20140916205406.GJ4322@dastard>
	<20140916210235.GA24591@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140916210235.GA24591@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>
Cc: tinguely@sgi.com, Olaf Weber <olaf@sgi.com>, xfs@oss.sgi.com

Hey Gents,

On Tue, Sep 16, 2014 at 02:02:35PM -0700, Christoph Hellwig wrote:
> On Wed, Sep 17, 2014 at 06:54:06AM +1000, Dave Chinner wrote:
> > So how do existing utf8/unicode enabled filesystems handle this? 
> > 
> > I think we should be consistent with ZFS, MacOS and others that
> > already deal with this problem if at all possible. 

Here's a data point from man(zfs):

       The following three properties cannot be	changed	after the file	system
       is  created,  and therefore, should be set when the file	system is cre-
       ated. If	the properties are not set with	the  "zfs  create"  or	"zpool
       create"	commands,  these  properties  are  inherited  from  the	parent
       dataset.	If the parent dataset lacks these  properties  due  to	having
       been created prior to these features being supported, the new file sys-
       tem will	have the default values	for these properties.

       casesensitivity = sensitive | insensitive | mixed

	   Indicates whether the file name matching algorithm used by the file
	   system  should be case-sensitive, case-insensitive, or allow	a com-
	   bination of both styles of matching.	 The  default  value  for  the
	   "casesensitivity"  property is "sensitive." Traditionally, UNIX and
	   POSIX file systems have case-sensitive file names.

	   The "mixed" value for the "casesensitivity" property	indicates that
	   the	file  system  can support requests for both case-sensitive and
	   case-insensitive  matching  behavior.  Currently,  case-insensitive
	   matching  behavior on a file	system that supports mixed behavior is
	   limited to the Solaris CIFS server product.	For  more  information
	   about the "mixed" value behavior, see the ZFS Administration	Guide.

       normalization =none | formD | formKCf

	   Indicates whether the file system should perform a unicode  normal-
	   ization  of	file  names  whenever two file names are compared, and
	   which normalization algorithm should	be used. File names are	always
	   stored  unmodified,	names are normalized as	part of	any comparison
	   process. If this property is	 set  to  a  legal  value  other  than
	   "none,"  and	 the  "utf8only"  property  was	 left unspecified, the
	   "utf8only" property is automatically	set to "on." The default value
	   of  the "normalization" property is "none." This property cannot be
	   changed after the file system is created.

       utf8only	=on | off

	   Indicates whether the file system should  reject  file  names  that
	   include characters that are not present in the UTF-8	character code
	   set.	If this	property is explicitly set to "off," the normalization
	   property must either	not be explicitly set or be set	to "none." The
	   default value for the "utf8only" property is	"off."	This  property
	   cannot be changed after the file system is created.

       The  "casesensitivity,"	"normalization," and "utf8only"	properties are
       also new	permissions that can be	assigned to  non-privileged  users  by
       using the ZFS delegated administration feature.

The original link:
https://www.freebsd.org/cgi/man.cgi?query=zfs&apropos=0&sektion=0&manpath=FreeBSD+8.1-RELEASE&format=html

> > However, this
> > really is a wider policy decision for the kernel/VFS as we want
> > consistent behaviour across all linux filesystems, hence this
> > patchset really needs to discussed at the lkml/-fsdevel level...
>
> Absolutely.  I've also talked to a few Samba folks at SDC, and one
> thing they would love to see is conditional case insensitive lookups,
> e.g.:
> 
>  - we hash case insensitive with collisions, but perform normal case
>    sensitive lookups.
>  - with a new AT_CASE_INSENSTIVE flag to the various *at calls that
>    gets passed down to the dcache we enable CI lookups.

I'm working on addressing some of the initial feedback and will be in a
position to post for a wider audience later in the week.

Thanks,
Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
