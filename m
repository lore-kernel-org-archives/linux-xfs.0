Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0AGgHlJ012345 for <xfs@oss.sgi.com>; Mon, 10 Jan 2011 10:42:17 -0600
Date: Mon, 10 Jan 2011 10:40:58 -0600
From: Geoffrey Wehrman <gwehrman@sgi.com>
Subject: Re: RedHat, Novell and SGI xfs kernel module api
Message-ID: <20110110164058.GC19571@sgi.com>
References: <CFFC47E79E870F4EBAD0CA24D8CD7652ED34D5BABE@CRW-EXM01.int.cggveritas.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CFFC47E79E870F4EBAD0CA24D8CD7652ED34D5BABE@CRW-EXM01.int.cggveritas.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: =?iso-8859-1?Q?Larsen=2C_Tore_H=F8ivaag?= <tore.hoivaag.larsen@cggveritas.com>
Cc: Alexis Cousein <al@sgi.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Mon, Jan 10, 2011 at 08:35:44AM +0000, Larsen, Tore H=F8ivaag wrote:
| Hi,
| =

|     currently we are purchasing Redhat's ScaleFS, SGI's cxfs, and Novell =
SLES xfs.
| =

|     Having e.g. Redhat XFS play nicely with cxfs client is not trivial. U=
sually, I have to choose ScaleFS w/lvm2 volumes og RHEL, but if I want cxfs=
, But I can't have local xvm volumes on 3rd party hw. =

| =

|     Is there plans to make an effort to making sure the xfs api is common=
 from the vendors and play nicely with each other ?    Comments? =


The community version of XFS is considered the defacto standard.  I must
compliment the community on doing an excellent job of maintaining
on-disk compatibiltiy within XFS as it has evolved.  On disk
compatibility is really the most critical API to maintain for a
filesystem.

Novell (and Red Hat) XFS will tend to lag the community top-of-tree XFS
some, as they are long life releases based on a fixed kernel version.
This somewhat restricts how much code can be backported from
top-of-tree XFS.

At SGI, we are always working on CXFS to maintain full compatibility
with community XFS.  CXFS is really just a distributed layer on top of
XFS, but we have to ship our own version of XFS with CXFS to provide all
of the interfaces requried by CXFS.  These interfaces have been removed
from community XFS as they have no purpose outside of CXFS which is SGI
proprietary software.


-- =

Geoffrey Wehrman
SGI Building 10                             Office: (651)683-5496
2750 Blue Water Road                           Fax: (651)683-5098
Eagan, MN 55121                             E-mail: gwehrman@sgi.com
	  http://www.sgi.com/products/storage/software/

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
