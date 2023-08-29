Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC7A8C6FA8F
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Aug 2023 17:31:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237453AbjH2RbF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Aug 2023 13:31:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237827AbjH2Raj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Aug 2023 13:30:39 -0400
X-Greylist: delayed 829 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 29 Aug 2023 10:30:14 PDT
Received: from smtp1.tecnico.ulisboa.pt (smtp1.tecnico.ulisboa.pt [IPv6:2001:690:2100:1::15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31D3C1B3
        for <linux-xfs@vger.kernel.org>; Tue, 29 Aug 2023 10:30:14 -0700 (PDT)
Received: from localhost (localhost.localdomain [127.0.0.1])
        by smtp1.tecnico.ulisboa.pt (Postfix) with ESMTP id 0DCDB60029A5;
        Tue, 29 Aug 2023 18:15:41 +0100 (WEST)
X-Virus-Scanned: by amavisd-new-2.11.0 (20160426) (Debian) at
        tecnico.ulisboa.pt
Received: from smtp1.tecnico.ulisboa.pt ([127.0.0.1])
        by localhost (smtp1.tecnico.ulisboa.pt [127.0.0.1]) (amavisd-new, port 10025)
        with LMTP id E_B-OmvtpgXX; Tue, 29 Aug 2023 18:15:37 +0100 (WEST)
Received: from mail1.tecnico.ulisboa.pt (mail1.ist.utl.pt [193.136.128.10])
        by smtp1.tecnico.ulisboa.pt (Postfix) with ESMTPS id 26D7860029B0;
        Tue, 29 Aug 2023 18:15:37 +0100 (WEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tecnico.ulisboa.pt;
        s=mail; t=1693329337;
        bh=y2qlVYHDTNZazb2V1a3OSC/vsobgfJrkWCPji5VcaOk=;
        h=Date:From:To:Subject;
        b=U4kh256rRl5J0934y89NwVvdOgeUN2fUUUlViyg+mEMF7n11mNrleVx0CJFav3uKy
         JpGElz3D9XSoZnElRp98Yc+mwoG0nmwaaBl0+oBSB8cnpPrxlDEP1z6WI07gzKHSXy
         CDsbdo7KH36N31eAwPDiyXXuo59+sJZJBcwWuRig=
Received: from picard (ff2-84-90-88-152.netvisao.pt [84.90.88.152])
        (Authenticated sender: ist24403)
        by mail1.tecnico.ulisboa.pt (Postfix) with ESMTPSA id 1065B360079;
        Tue, 29 Aug 2023 18:15:36 +0100 (WEST)
Received: from cal by picard with local (Exim 4.94.2)
        (envelope-from <jose.calhariz@tecnico.ulisboa.pt>)
        id 1qb2JU-001EXq-4x; Tue, 29 Aug 2023 18:15:36 +0100
Date:   Tue, 29 Aug 2023 18:15:36 +0100
From:   Jose M Calhariz <jose.calhariz@tecnico.ulisboa.pt>
To:     linux-xfs@vger.kernel.org
Subject: Data corruption with XFS on Debian 11 and 12 under heavy load.
Message-ID: <ZO4nuHNg+KFzZ2Qz@calhariz.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="nAjuNULRmJ8IW6sk"
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


--nAjuNULRmJ8IW6sk
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Hi,

I have been chasing a data corruption problem under heavy load on 4
servers that I have at my care.  First I thought of an hardware
problem because it only happen with RAID 6 disks.  So I reported to Debian:=
=20

https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1032391

Further research pointed to be the XFS the common pattern, not an
hardware issue.  So I made an informal query to a friend in a software
house that relies heavily on XFS about his thought on this issue.  He
made reference to several problems fixed on kernel 6.2 and a
discussion on this mailing list about back porting the fixes to 6.1
kernel.

With this information I have tried the latest kernel at that time on
Debian testing over Debian v12 and I could not reproduce the
problem.  So I made another bug report:

https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1040416

My questions to this mailing list:

  - Have anyone experienced under Debian or with vanilla kernels
  corruption under heavy load on XFS?

  - Should I stop waiting for the fixes being back ported to vanilla
  6.1 and run the latest kernel from Debian testing anyway?  Taking
  notice that kernels from testing have less security updates on time
  than stable kernels, specially security issues with limited
  disclosure.


I am happy to provide more info about my setup or my stability tests
that fail under XFS.


Kind regards
Jose M Calhariz

--=20
--
Um falso amigo nunca o xinga

Um verdadeiro amigo j=E1 o xingou de tudo quanto =E9
palavr=E3o que existe - e at=E9 inventou alguns novos

--nAjuNULRmJ8IW6sk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEERkvHzUOf7l6LQJigNIp3jWiF748FAmTuJ68ACgkQNIp3jWiF
74+6rg//WJQXfo6Rjio3SIVM3o+iMRzcvvWBUvnVHDDqY7YkYcj+JjIFReIyG8jA
9D8KzE43sDEmrkumtYWjbNN5VGYoMDXHtVEZm+LKRkFt56FnN955tV7axRAuYVfG
G2Of2C4SIwLlaDk8dNUb1UN0FaH3AA4QLnY22n1T5HfPOS7FnJWiyTEyZCLhtddX
0yVMpMGVUnGqrfHEjzvG+ifYKYIm6B0xOuUPij+Hqnw8l63EL5waQUjXBhVThrFb
Hdv+dGZ8GxG3+zwL1WaZyxQPRERjxLGr68KxJP4bLAcCzzUXjbg5LQ5wY5avyjPn
oxMdirurzX2Ve0FB6+6ch/1dIbMSAAxp4M7vF6u0lO1jHhXnTvP/ToRDKVivf+wj
uxxlWxmF79H1zCkpMZnwbs1Sfu54o8jShgjrb2EecGfuLKS+1a5ibBNz3bYvtlUJ
iHwJOwu5YXFy5IgE/pXys0mnMzEVXvzLQccG3/G01Y6fjp/5lERa1g2QFofeICN9
Ryh0rbAnLWC1LOfUysOQOojq3uAXJUe1mUQkOYO4D1mnrxThWqppADuYrYTIXYk3
Uv3EBtfQIiaiqwCHMN6HJw3nO6pY+5LX5YkjZeVq814Xk2J6D6CxxJFl4TjO5+07
L8UHtvlMK/kC7trsy3HQuI5gKbr/4JUnyQfd8L5+t76DELqsht0=
=5kKK
-----END PGP SIGNATURE-----

--nAjuNULRmJ8IW6sk--
