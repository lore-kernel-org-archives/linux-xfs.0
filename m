Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 81E6D7F37
	for <xfs@oss.sgi.com>; Tue,  6 Oct 2015 11:16:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 684368F8037
	for <xfs@oss.sgi.com>; Tue,  6 Oct 2015 09:16:50 -0700 (PDT)
Received: from morework.geizhals.at (morework.geizhals.at [78.142.138.3]) by
	cuda.sgi.com with ESMTP id 21aUzBKZNgTPW2gC (version=TLSv1
	cipher=DHE-RSA-AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 06 Oct 2015 09:16:47 -0700 (PDT)
Message-ID: <eb3a907a5224885d97b47c86a9293545.squirrel@mail.geizhals.at>
In-Reply-To: <20151006145038.GE10397@birch.djwong.org>
References: <20151006162443.42f48ee7@linux>
	<20151006145038.GE10397@birch.djwong.org>
Date: Tue, 6 Oct 2015 18:16:46 +0200
Subject: Re: all your slabs are belong to ram ?
From: "Johannes Truschnigg" <johannes.truschnigg@geizhals.at>
MIME-Version: 1.0
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
To: xfs@oss.sgi.com
Cc: "krautus@kr916.org" <krautus@kr916.org>

Am Di, 6.10.2015, 16:50 schrieb Darrick J. Wong:
> On Tue, Oct 06, 2015 at 04:24:43PM +0200, krautus@kr916.org wrote:
>> [...]
>> So I'm asking you:
>> 1. is there a way to force dentries and inodes to stay in ram ?
>> 2. can I perhaps move dentries and inodes to a dedicated SSD ?
>>
>> I'm open to all possibilities, perhaps increase RAM ?
>> Upgrade to Debian Jessie and 64 bit ?
>
> ISTR that kernel data such as slabs cannot live in highmem, which means
> that
> dentries and slab cannot live in highmem.  A 32bit kernel sets up ~900M of
> low
> memory and ~15G of highmem, which is probably why the kernel has to evict
> things and why you see such problems.
>
> A 64bit kernel sets up all the memory as lowmem, so the kernel can use all
> the
> memory for stuff like that.  I'd give that a try first.

A few years back, we solved pretty much that exact same problem by
switching the kernel to amd64, with all of userspace remaining i386. You
should definitely try this.

-- =

Mit freundlichen Gr=FC=DFen
Johannes Truschnigg
Senior System Administrator
--
mailto:johannes.truschnigg@geizhals.at (in dringenden F=E4llen bitte an
info@geizhals.at)

Geizhals(R) - Preisvergleich Internet Services AG
Obere Donaustrasse 63/2
A-1020 Wien
Tel: +43 1 5811609/87
Fax: +43 1 5811609/55
http://geizhals.at =3D> Preisvergleich f=FCr =D6sterreich
http://geizhals.de =3D> Preisvergleich f=FCr Deutschland
http://geizhals.eu =3D> Preisvergleich EU-weit
Handelsgericht Wien | FN 197241K | Firmensitz Wien

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
