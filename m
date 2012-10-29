Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9T89dGN144630 for <xfs@oss.sgi.com>; Mon, 29 Oct 2012 03:09:39 -0500
Received: from smtp-tls.univ-nantes.fr (smtptls1-loi.cpub.univ-nantes.fr
	[193.52.103.112]) by cuda.sgi.com with ESMTP id
	IVHLPoTqyEQOLsDU for <xfs@oss.sgi.com>;
	Mon, 29 Oct 2012 01:11:27 -0700 (PDT)
Message-ID: <508E3A2E.20901@univ-nantes.fr>
Date: Mon, 29 Oct 2012 09:11:26 +0100
From: Yann Dupont <Yann.Dupont@univ-nantes.fr>
MIME-Version: 1.0
Subject: Re: Problems with kernel 3.6.x (vm ?) (was : Is kernel 3.6.1 or
	filestreams option toxic ?)
References: <508554AF.5050005@univ-nantes.fr> <50865453.5080708@univ-nantes.fr>
	<508958FF.4000007@univ-nantes.fr> <20121025211047.GD29378@dastard>
	<508A600C.1020109@univ-nantes.fr> <508B092E.6070209@univ-nantes.fr>
	<20121028234802.GE4353@dastard> <20121029012540.GO29378@dastard>
In-Reply-To: <20121029012540.GO29378@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Le 29/10/2012 02:25, Dave Chinner a =E9crit :
> I can't reproduce this with a similar setup but using KVM (i.e. =

> killing the VM instead of power cycling) or forcing a shutdown of the =

> filesystem without flushing the log. The second case is very much the =

> same as power cycling, but without the potential "power failure caused =

> partial IOs to be written" problem. The only thing I can see in the =

> logprint that I haven't seen so far in my testing is that your log =

> print indicates a checkpoint that wraps the end of the log. I haven't =

> yet hit that situation by chance, so I'll keep trying to see if that's =

> the case that is causing the problem.... Cheers, Dave. =


Ok, is your kvm guest was lvm enabled ?

I'll try to recrash the FS, this time I'll make an image of it on =

another machine for further testings. And I'll supply a usefull logprint

Cheers,

-- =

Yann Dupont - Service IRTS, DSI Universit=E9 de Nantes
Tel : 02.53.48.49.20 - Mail/Jabber : Yann.Dupont@univ-nantes.fr

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
