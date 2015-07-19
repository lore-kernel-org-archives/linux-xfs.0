Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3241F7F47
	for <xfs@oss.sgi.com>; Sat, 18 Jul 2015 20:03:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B0D7BAC001
	for <xfs@oss.sgi.com>; Sat, 18 Jul 2015 18:03:00 -0700 (PDT)
Received: from mail03.lsn.net (mail03.lsn.net [66.90.130.130]) by cuda.sgi.com
	with ESMTP id 6GLUf1tT0q6Wg8lK for <xfs@oss.sgi.com>;
	Sat, 18 Jul 2015 18:02:53 -0700 (PDT)
Message-ID: <55AAF73A.4040903@mygrande.net>
Date: Sat, 18 Jul 2015 20:02:50 -0500
From: Leslie Rhorer <lrhorer@mygrande.net>
MIME-Version: 1.0
Subject: Re: XFS File system in trouble
References: <03864DDC681E664EBF5D47682BE7D7CF0D3574DF@USADCWVEMBX07.corp.global.level3.com>	<55AA5FCE.4080702@sandeen.net>	<03864DDC681E664EBF5D47682BE7D7CF0D358740@USADCWVEMBX07.corp.global.level3.com>
	<CAN3tLtJuk3LKHtxvbXATBR7bjr2e=GTX-fgs-jQniuxqRXjeoA@mail.gmail.com>
In-Reply-To: <CAN3tLtJuk3LKHtxvbXATBR7bjr2e=GTX-fgs-jQniuxqRXjeoA@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Kris Rusocki <kszysiu@braxis.org>, "Rhorer, Leslie" <Leslie.Rhorer@level3.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>


	I found the problem with md5sum (and probably nfs, as well).  One of 
the memory modules in the server was bad.  The problem with XFS 
persists.  Every time tar tried to create the directory:

/RAID/Server-Main/Equipment/Drive Controllers/HighPoint Adapters/Rocket 
2722/Driver/RR276x/Driver/Linux/openSUSE/rr276x-suse-11.2-i386/linux/suse/i386-11.1

	It would begin spitting out errors, starting with "Cannot mkdir: 
Structure needs cleaning".  At that point, XFS had shut down.  I went 
into /RAID/Server-Main/Equipment/Drive Controllers/HighPoint 
Adapters/Rocket 
2722/Driver/RR276x/Driver/Linux/openSUSE/rr276x-suse-11.2-i386/linux/suse/ 
and created the i386-11.1 directory by hand, and tar no longer starts 
spitting out errors at that point, but it does start up again at 
RR2782/Windows/Vista-Win2008-Win7-legacy_single/x64.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
