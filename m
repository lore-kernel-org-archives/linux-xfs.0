Return-Path: <SRS0=yyqk=36=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA919C352A3
	for <linux-xfs@archiver.kernel.org>; Mon, 10 Feb 2020 10:33:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 554E32080C
	for <linux-xfs@archiver.kernel.org>; Mon, 10 Feb 2020 10:33:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=jore.no header.i=@jore.no header.b="MPchViox";
	dkim=pass (2048-bit key) header.d=outbound.mailhop.org header.i=@outbound.mailhop.org header.b="CFLIMt/X"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726968AbgBJKdR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 10 Feb 2020 05:33:17 -0500
Received: from outbound2m.ore.mailhop.org ([54.149.155.156]:10396 "EHLO
        outbound2m.ore.mailhop.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726961AbgBJKdR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Feb 2020 05:33:17 -0500
ARC-Seal: i=1; a=rsa-sha256; t=1581330793; cv=none;
        d=outbound.mailhop.org; s=arc-outbound20181012;
        b=Vv+HdgEQOIDJRFmb0+o3FaEqLV/0ElTmEVpZ9Flp3XwfC+uTQKCoO4yJSxS0xIJzbLiopnHBZyN3w
         Uv0csvaRPUyIbKnXrHscYi8QcvMqDp6hNSrPKzJH6nmgwpIFIny+DGNqrMG4YyTz4UWJhZ3yd8uyOc
         hO2a1VtcYJvVegfU2uHRT9AHqMAmC4P1suIIZd67GgEkA3AjGeB2uu3j6zdtln6q0eH01pUkYTwtWM
         UQ8B8HbsJLVWclrTW/5ykEhmv+6y/m4HdBoY5nfTAg3NaJAEzve7OVQx1zXlFh9A6BaH5mfDADv9BN
         sa10xUvxEnKk9kpS/JFQrKPkG7sy3kQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
        d=outbound.mailhop.org; s=arc-outbound20181012;
        h=mime-version:content-transfer-encoding:content-type:in-reply-to:references:
         message-id:date:subject:to:from:dkim-signature:dkim-signature:from;
        bh=RM74OcptrLHmCFxkloo7JsLy3c0itXeX7I/fVGckENo=;
        b=KrlnE2u6vZnY3h0UtHIOiq9Ldw5+rTcYQWwZ5F/Uc4Fqpb/u5vGdR2iQSY0qIr6oNmbNmM1ZosSmU
         2FQgXLVqxp8keV8ifukQBiRoWhV2X5u6oYhcpg+5r7Dt1q6SEZsZ5aaB0G5oBR24QAeDAHv4U4+BSK
         OhhVsAQzHiCIVkefzaFW8/piv6dpACzq1DaBFTYa1rp/bwNI5SI4ep7W7KSYibB1zJFTKdUTRASoFW
         +2qiokkpAVbsI+kdki2Ayl9mSw9n4yKvgVGnftIryEbyvhWp84jDKtKGyANd2SI68aoky7956V33Kh
         dseCEFhH4Fkpkmdj5cbKEhlmqQ3bXzw==
ARC-Authentication-Results: i=1; outbound4.ore.mailhop.org;
        spf=pass smtp.mailfrom=jore.no smtp.remote-ip=27.96.199.243;
        dmarc=none header.from=jore.no;
        arc=none header.oldest-pass=0;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=jore.no; s=duo-1579427507040-bf9c4b8d;
        h=mime-version:content-transfer-encoding:content-type:in-reply-to:references:
         message-id:date:subject:to:from:from;
        bh=RM74OcptrLHmCFxkloo7JsLy3c0itXeX7I/fVGckENo=;
        b=MPchVioxv6J5w72uEKrrRqDQAjIM3l4st4hKL6FrMzZyUmzgyp+vaFfSNrh38zqXFEPfP2hn+Ksz/
         JWjhYb7sSRsE9riYUIYJNr+L4MCTzht34T8Vo4e9vE/M6RV4xUZPu62nY60HOFZEVt59QU5JuL1ZXK
         2tBKGOsS07echPaU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=outbound.mailhop.org; s=dkim-high;
        h=mime-version:content-transfer-encoding:content-type:in-reply-to:references:
         message-id:date:subject:to:from:from;
        bh=RM74OcptrLHmCFxkloo7JsLy3c0itXeX7I/fVGckENo=;
        b=CFLIMt/Xp4HZLkVusbwj96ZGa1dsoELPPl1FLROX7Plr7IiyaxAtzri+qAb5BQ0NP5wyqyHl6TFIQ
         j9mYjqRgZiU6ybwv8uBGctXvrmLlpKS3KzR4itEKASKu3WdF6GPwTvNjAXz9doFqSUlmvnPBoSumz+
         cIm9rVOLWfrvhhsdNC6wXkkLrSQLFjepvN27gHyd+P0aStC61ibsS9cl1JK++3maB4kf5m17k428/V
         kha2fF7iETrrF8Ky8XYzeu46FXo8HNtPwILurcQ0veSXXAwOW1rCAR4CXOFc6It7fxfDkT3g6I9hne
         RcX0Pa8aLWNG2VWic703lQNoT1Aw4Gw==
X-MHO-RoutePath: am9obmpvcmU=
X-MHO-User: b9fbe756-4bf0-11ea-9eb3-25e2dfa9fa8d
X-Report-Abuse-To: https://support.duocircle.com/support/solutions/articles/5000540958-duocircle-standard-smtp-abuse-information
X-Mail-Handler: DuoCircle Outbound SMTP
Received: from mail.jore.no (unknown [27.96.199.243])
        by outbound4.ore.mailhop.org (Halon) with ESMTPSA
        id b9fbe756-4bf0-11ea-9eb3-25e2dfa9fa8d;
        Mon, 10 Feb 2020 10:33:10 +0000 (UTC)
Received: from SNHNEXE02.skynet.net (192.168.1.14) by SNHNEXE02.skynet.net
 (192.168.1.14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.330.5; Mon, 10 Feb 2020
 21:33:06 +1100
Received: from SNHNEXE02.skynet.net ([fe80::ad3a:937:9347:f03b]) by
 SNHNEXE02.skynet.net ([fe80::ad3a:937:9347:f03b%12]) with mapi id
 15.02.0330.010; Mon, 10 Feb 2020 21:33:06 +1100
From:   John Jore <john@jore.no>
To:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: Bug in xfs_repair 5..4.0 / Unable to repair metadata corruption
Thread-Topic: Bug in xfs_repair 5..4.0 / Unable to repair metadata corruption
Thread-Index: AQHV3woCeKF9LncMXUyAW7OQrNKp4qgSYvxVgACwHQCAAACAgIABI+yXgAAFN/c=
Date:   Mon, 10 Feb 2020 10:33:06 +0000
Message-ID: <5f80fcd0870145579310ca347931fbd6@jore.no>
References: <186d30f217e645728ad1f34724cbe3e7@jore.no>
 <b2babb761ed24dc986abc3073c5c47fc@jore.no>
 <74152f80-3a42-eab5-a95f-e29f03db46a9@sandeen.net>,<c04772bf-c1da-87f2-3070-52deb2afda06@sandeen.net>,<60f32c031f4345a2b680fbc8531f7bd3@jore.no>
In-Reply-To: <60f32c031f4345a2b680fbc8531f7bd3@jore.no>
Accept-Language: en-GB, nb-NO, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
X-Originating-IP: 27.96.199.243
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi and no, that message appears when -d is used, even if the volume is not =
mounted (at least on the current version from git)=A0

The help page states this for -d, given that the metadata=A0corruption coul=
d=A0not be repaired without the option, I=A0gave it a try (there is no ment=
ion that this supports mounted volumes?):
 -d=A0 =A0 =A0 =A0 =A0 =A0Repair dangerously.



 John

----


From: Eric Sandeen <sandeen@sandeen.net>
Sent: 10 February 2020 14:49
To: John Jore; linux-xfs@vger.kernel.org
Subject: Re: Bug in xfs_repair 5..4.0 / Unable to repair metadata corruptio=
n
=A0  =20
On 2/9/20 9:47 PM, Eric Sandeen wrote:
> On 2/9/20 12:19 AM, John Jore wrote:

...

>> Does not matter how many times, I've lost count, I re-run xfs_repair, wi=
th, or without -d,
>=20
> -d is for repairing a filesystem while mounted.=A0 I hope you are not doi=
ng that, are you?

"Repair of readonly mount complete.=A0 Immediate reboot encouraged."

er, maybe you are.=A0 Why?

-Eric
        =
