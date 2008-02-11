Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 11 Feb 2008 13:23:27 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1BLNHBD014435
	for <xfs@oss.sgi.com>; Mon, 11 Feb 2008 13:23:21 -0800
Received: from out4.smtp.messagingengine.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8ED58DE5184
	for <xfs@oss.sgi.com>; Mon, 11 Feb 2008 13:23:40 -0800 (PST)
Received: from out4.smtp.messagingengine.com (out4.smtp.messagingengine.com [66.111.4.28]) by cuda.sgi.com with ESMTP id 8Mu7Ek7W3NQtGPKs for <xfs@oss.sgi.com>; Mon, 11 Feb 2008 13:23:40 -0800 (PST)
Message-Id: <1202764989.11126.1236296081@webmail.messagingengine.com>
From: "Felix E. Klee" <felix.klee@inka.de>
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="ISO-8859-1"
MIME-Version: 1.0
References: <1202748389.28320.1236240801@webmail.messagingengine.com>
   <20080211171209.GA7567@teal.hq.k1024.org>
Subject: Re: Data safety horror stories?
In-Reply-To: <20080211171209.GA7567@teal.hq.k1024.org>
Date: Mon, 11 Feb 2008 22:23:09 +0100
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Iustin Pop <iusty@k1024.org>
Cc: xfs-oss <xfs@oss.sgi.com>

Hi Justin,

thanks for the info!

On Mon, 11 Feb 2008 18:12:09 +0100, "Iustin Pop" <iusty@k1024.org> said:
> No, XFS will not lose any data that the application has committed to
> the disk.

OK, but just to make sure: The following FAQ entry refers only to
*newly* created files - right?

http://oss.sgi.com/projects/xfs/faq.html#nulls

> Improperly written applications and/or improperly configured systems
> might have issues with recently written files losing data.

Again, just to make sure that I understood you correctly: Could you name
an example?

> Be sure the read the FAQ, especially the section about write cache on
> dekstop/consumer HDDs.

You are probably referring to the following entry.  I now disabled the
write cache of the 2nd HDD in Windows (remember my configuration).  I
wonder though: Wouldn't it be possible to design journaling in a way so
that the write cache does never cause problems? Could someone provide an
example which illustrates the write cache problem in simple terms?

http://oss.sgi.com/projects/xfs/faq.html#wcache

> Just my opinion as an XFS user, your mileage might vary.

Hopefully, it's not about opinions ...

- Felix
-- 
Dipl.-Phys. Felix E. Klee
Naunynstr. 2, 76530 Baden-Baden, Germany
Tel.: +49 7221 396961, Fax: +49 7221 396960, Mobile: +49 174 1386060
http://www.linkedin.com/in/feklee
