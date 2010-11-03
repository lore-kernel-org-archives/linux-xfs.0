Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oA3Npdkf113965 for <xfs@oss.sgi.com>; Wed, 3 Nov 2010 18:51:40 -0500
Received: from mail-gw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6C5401519CA
	for <xfs@oss.sgi.com>; Wed,  3 Nov 2010 16:53:02 -0700 (PDT)
Received: from mail-gw0-f53.google.com (mail-gw0-f53.google.com
	[74.125.83.53]) by cuda.sgi.com with ESMTP id Y2aUVXoCP0j8IZ7s
	for <xfs@oss.sgi.com>; Wed, 03 Nov 2010 16:53:02 -0700 (PDT)
Received: by gwb1 with SMTP id 1so1085978gwb.26
	for <xfs@oss.sgi.com>; Wed, 03 Nov 2010 16:53:02 -0700 (PDT)
Message-ID: <4CD1F5D7.6020606@timsesow.com>
Date: Wed, 03 Nov 2010 17:52:55 -0600
From: Timothy Sesow <tsesow@gmail.com>
MIME-Version: 1.0
Subject: Re: Linux and DMAPI
References: <AANLkTim5FExj9GFQf9v1rzRmxqtNrdw_UR5VPUs4bPMq@mail.gmail.com>
	<E1PDl8r-000N7I-Hb@intern.SerNet.DE>
In-Reply-To: <E1PDl8r-000N7I-Hb@intern.SerNet.DE>
Reply-To: tim@timsesow.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: =?ISO-8859-1?Q?Bj=F6rn_JACKE?= <bj@sernet.de>
Cc: Diego Woitasen <diego@woitasen.com.ar>, xfs@oss.sgi.com

In the latest tarball at http://dvdvault.sourceforge.net is a
routine called "dmapid" that has a user-space implementation
of a DMAPI service routine, plus a copy of some example source
code from SGI.  Plus there is a "purgefile" program to poke holes
in files in the "migration" directory.  The most recent upload was last =

month.

The tricky parts of session management and event handling are in
the dmapid code.

Its been run against a kernel build from SGI's XFS baseline
(most recently on 2.6.24).  You will either have to go back to
a prior kernel build to get DMAPI included, or run a patch against
a current version of the LINUX kernel.


On 11/03/2010 03:44 PM, Bj=F6rn JACKE wrote:
> On 2010-09-18 at 21:08 -0300 Diego Woitasen sent off:
>> Hi,
>>   I'm looking for software that supports DMAPI on Linux. I haven't
>> found anything on the web. I need to implement HSM for a mail server,
>> to store old messages in a secondary storage.
>>
>>   Are there something implemented? Open source or propietary one? I
>> prefer open source obviously...
> unmaintained since years but might be interesting for you:
> http://sourceforge.net/projects/openhsm/
>
> The only Linux distri I know that contains XFS with DMAPI support is
> SLES 8/9/10 (not sure about 11).
>
> Bj=F6rn

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
