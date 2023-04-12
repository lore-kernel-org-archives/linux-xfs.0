Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2744BC7619A
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Apr 2023 13:59:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229764AbjDLN7K (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 Apr 2023 09:59:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229799AbjDLN7K (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Apr 2023 09:59:10 -0400
Received: from tmailer.gwdg.de (tmailer.gwdg.de [134.76.10.23])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0329B7ABF
        for <linux-xfs@vger.kernel.org>; Wed, 12 Apr 2023 06:58:56 -0700 (PDT)
Received: from excmbx-12.um.gwdg.de ([134.76.9.221] helo=email.gwdg.de)
        by mailer.gwdg.de with esmtp (GWDG Mailer)
        (envelope-from <Ansgar.Esztermann@mpinat.mpg.de>)
        id 1pmZyb-000BEk-9u
        for linux-xfs@vger.kernel.org; Wed, 12 Apr 2023 14:53:30 +0200
Received: from aeszter.mpibpc.intern (10.250.9.199) by EXCMBX-12.um.gwdg.de
 (134.76.9.221) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P521) id 15.1.2507.23; Wed, 12
 Apr 2023 14:53:29 +0200
Date:   Wed, 12 Apr 2023 14:53:28 +0200
From:   Ansgar Esztermann-Kirchner <aeszter@mpinat.mpg.de>
To:     <linux-xfs@vger.kernel.org>
Subject: Re: Replacing the external log device
Message-ID: <ZDapyHDzMVjD2Qk/@aeszter.mpibpc.intern>
Mail-Followup-To: linux-xfs@vger.kernel.org
References: <ZDZb/PtvFlyIMKDG@aeszter.mpibpc.intern>
 <ZDafWCuO8iZB1Vev@infradead.org>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature";
        micalg=sha-256; boundary="a3ClU/92GM1mAWoW"
Content-Disposition: inline
In-Reply-To: <ZDafWCuO8iZB1Vev@infradead.org>
X-Originating-IP: [10.250.9.199]
X-ClientProxiedBy: EXCMBX-13.um.gwdg.de (134.76.9.222) To EXCMBX-12.um.gwdg.de
 (134.76.9.221)
X-Virus-Scanned: (clean) by clamav
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

--a3ClU/92GM1mAWoW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 12, 2023 at 05:08:56AM -0700, Christoph Hellwig wrote:
> Let me restate that:  you created a new XFS file system, but then tried
> to reuse an existing log device for it?

Yes (more or less, as the existing log device should be reformatted by
xfs_repair).
=20
> How did you format the new file system?  XFS either expects and internal
> log, or a log device?  For the above error it must have been formatted
> with a different external log? =20

Yes, that's correct.

> And then you just switched the mount
> option to the log device of the previous file system?

I physically replaced the disks.

> If so that can't work, and I'm surprised you got so far.

Hmm. Does that mean a zeroed log is still different from one that has
been freshly created? If that is true, then that would be a difference
=66rom the "working" and "not working" cases.
Or do you mean that a log device cannot be replaced even if it is
physically damaged?

A.

--=20
Ansgar Esztermann
Sysadmin Dep. Theoretical and Computational Biophysics
https://www.mpinat.mpg.de/person/11315/3883774

--a3ClU/92GM1mAWoW
Content-Type: application/x-pkcs7-signature
Content-Disposition: attachment; filename="smime.p7s"
Content-Transfer-Encoding: base64

MIITTQYJKoZIhvcNAQcCoIITPjCCEzoCAQExDzANBglghkgBZQMEAgEFADALBgkqhkiG9w0B
BwGggg+kMIIHzjCCBbagAwIBAgIRAK57XEudnCkGBNyOR+tM4E0wDQYJKoZIhvcNAQEMBQAw
RjELMAkGA1UEBhMCTkwxGTAXBgNVBAoTEEdFQU5UIFZlcmVuaWdpbmcxHDAaBgNVBAMTE0dF
QU5UIFBlcnNvbmFsIENBIDQwHhcNMjExMjE1MDAwMDAwWhcNMjQxMjE0MjM1OTU5WjCCASkx
DjAMBgNVBBETBTgwNTM5MUgwRgYDVQQLDD9NYXgtUGxhbmNrLUluc3RpdHV0IGbDvHIgTXVs
dGlkaXN6aXBsaW7DpHJlIE5hdHVyd2lzc2Vuc2NoYWZ0ZW4xRzBFBgNVBAoTPk1heC1QbGFu
Y2stR2VzZWxsc2NoYWZ0IHp1ciBGb2VyZGVydW5nIGRlciBXaXNzZW5zY2hhZnRlbiBlLlYu
MRswGQYDVQQJDBJIb2ZnYXJ0ZW5zdHJhw59lIDgxDzANBgNVBAgTBkJheWVybjELMAkGA1UE
BhMCREUxIzAhBgNVBAMTGkFuc2dhciBFc3p0ZXJtYW5uLUtpcmNobmVyMSQwIgYJKoZIhvcN
AQkBFhVhZXN6dGVyQG1waW5hdC5tcGcuZGUwggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIK
AoICAQC+4PRgbnBGLkFOUTXwzSri/tenyO83YUB/w+EZqaQy6b9zhws9Vu+7E2cruJEwVywo
U6/02ZGFbdUqnGBJdAPutxM0Zsf3TPfSvjp5MRyu+jFrI+JEz7bYh5puLPi9nZqrwgKxfFNB
eu2z69slaNIr4gXz0jue3ObqkURZA98VTYNkEhnvoEwQ/d8NHPApaXPV5BsysbAiAaBKUgzu
HdKM0Ar51AVFRz/eR+dj5rGIbxDHjgkey1tyfAQ8XUJghikS4D64L5FbgY+CIfXK71prvWLu
7oU8vf3LqYkdPe+Dxal/vZBMzHVQsWgcPWZ1DI3iu3j1pG6efd/Oz4Q/PzH8+y6Gx6LPlmGK
abwLbKC67ckF38dVNFY+mkrbDtapeN52E3U3QbTGF02P53YUB7xks/PuLhmFbDm7uzlMadUk
B0Pg7hN5yg2nTQtprA/PAWE9CnjduMllrQuPRT2UZyDlMGxl+J+LHU2tRsbQI7kxx/UsnkM1
oRYvNEw8UjhxoeniNpZHfRi66KXvQ1ipS5mJxRsjZKUszpWH1Vq04wmHziOkBF1xlfN2xXqg
huWBYIFigJXODMeJFn098jMgq6xkGyi3YWIwQx4bSFzlbGnV3/yDlXnyLsha33fmAjAiTNle
QKqnb9TZk5CbPbEk39Yi++g/3uSyX+tAD+sUcPhIEwIDAQABo4IB0DCCAcwwHwYDVR0jBBgw
FoAUaQChxyFY+ODFGyCwCt2nUb8T2eQwHQYDVR0OBBYEFJKxmPXcHI/LhG55dDxl/0UAbTXN
MA4GA1UdDwEB/wQEAwIFoDAMBgNVHRMBAf8EAjAAMB0GA1UdJQQWMBQGCCsGAQUFBwMEBggr
BgEFBQcDAjA/BgNVHSAEODA2MDQGCysGAQQBsjEBAgJPMCUwIwYIKwYBBQUHAgEWF2h0dHBz
Oi8vc2VjdGlnby5jb20vQ1BTMEIGA1UdHwQ7MDkwN6A1oDOGMWh0dHA6Ly9HRUFOVC5jcmwu
c2VjdGlnby5jb20vR0VBTlRQZXJzb25hbENBNC5jcmwweAYIKwYBBQUHAQEEbDBqMD0GCCsG
AQUFBzAChjFodHRwOi8vR0VBTlQuY3J0LnNlY3RpZ28uY29tL0dFQU5UUGVyc29uYWxDQTQu
Y3J0MCkGCCsGAQUFBzABhh1odHRwOi8vR0VBTlQub2NzcC5zZWN0aWdvLmNvbTBOBgNVHREE
RzBFgRVhZXN6dGVyQG1waW5hdC5tcGcuZGWBFWFlc3p0ZXJAbXBpYnBjLm1wZy5kZYEVYWVz
enRlckBtcGluYXQubXBnLmRlMA0GCSqGSIb3DQEBDAUAA4ICAQAyB4qOpUH0wHxx8TurDrOS
A6rgIJk5DJlycJAVvU7FITJjojCEjyyqrTHTnJ6I6A+phzggHm+knT5+QhMSMA6J4zzXEIqN
IH/4KpM1J/4s9KQf/mnVEP7idefg29Ff2wbTfv8moxRS0mf/PII4iqsJrtsTCqrMGPbfvWFm
5MIVeCtt+ZpDFOTaBdFqdH9ZAfQEwQr2Vzg9j7juaJr4J6D5TbrO+EYQxUEqrX0rmgYr4fSC
TrJ/WSYXIGM4Ib4GLhl8fKIQ3nw16ZIzdRmgobaSsjSGgXCzo1J5dzQ+EXDlp7oLIyRMH4VC
glYMWyRxckjdyG7hvkdXaF1/UJ87hqI3RCR1SOr6QFS8P5q/mX/ZiC2JG1dkcY/qNb9UohGr
UFCsylsXXdsEmKCl+dUBMqKuuQHR+opVpMmlSJkO5XpSmNEAwTQKV3JKj/ea9GbnzyvQeM5g
Mk0YoOcbymlZZzJKNZdpVmUA47tv7R6MKjKzoX97/UMPT65U5qNRBXp2YwykyxI+WP5KKs/1
oFJwJ71aFllHuJrEmbzw4T6mKpKNrdECnJaeg0ueb4/w6ZXmKcd95NZZjcrd4G8xEbxc8kZH
JVh2A57DlVIKqEdlhIgV0r9o1itsJ6Jf8Ie2Vao1l7j5GZeC8eCXyZr/IRHM8Qi/NRL7Nq5G
aztYjqZLkgOQxDCCB84wggW2oAMCAQICEQCue1xLnZwpBgTcjkfrTOBNMA0GCSqGSIb3DQEB
DAUAMEYxCzAJBgNVBAYTAk5MMRkwFwYDVQQKExBHRUFOVCBWZXJlbmlnaW5nMRwwGgYDVQQD
ExNHRUFOVCBQZXJzb25hbCBDQSA0MB4XDTIxMTIxNTAwMDAwMFoXDTI0MTIxNDIzNTk1OVow
ggEpMQ4wDAYDVQQREwU4MDUzOTFIMEYGA1UECww/TWF4LVBsYW5jay1JbnN0aXR1dCBmw7xy
IE11bHRpZGlzemlwbGluw6RyZSBOYXR1cndpc3NlbnNjaGFmdGVuMUcwRQYDVQQKEz5NYXgt
UGxhbmNrLUdlc2VsbHNjaGFmdCB6dXIgRm9lcmRlcnVuZyBkZXIgV2lzc2Vuc2NoYWZ0ZW4g
ZS5WLjEbMBkGA1UECQwSSG9mZ2FydGVuc3RyYcOfZSA4MQ8wDQYDVQQIEwZCYXllcm4xCzAJ
BgNVBAYTAkRFMSMwIQYDVQQDExpBbnNnYXIgRXN6dGVybWFubi1LaXJjaG5lcjEkMCIGCSqG
SIb3DQEJARYVYWVzenRlckBtcGluYXQubXBnLmRlMIICIjANBgkqhkiG9w0BAQEFAAOCAg8A
MIICCgKCAgEAvuD0YG5wRi5BTlE18M0q4v7Xp8jvN2FAf8PhGamkMum/c4cLPVbvuxNnK7iR
MFcsKFOv9NmRhW3VKpxgSXQD7rcTNGbH90z30r46eTEcrvoxayPiRM+22Ieabiz4vZ2aq8IC
sXxTQXrts+vbJWjSK+IF89I7ntzm6pFEWQPfFU2DZBIZ76BMEP3fDRzwKWlz1eQbMrGwIgGg
SlIM7h3SjNAK+dQFRUc/3kfnY+axiG8Qx44JHstbcnwEPF1CYIYpEuA+uC+RW4GPgiH1yu9a
a71i7u6FPL39y6mJHT3vg8Wpf72QTMx1ULFoHD1mdQyN4rt49aRunn3fzs+EPz8x/Psuhsei
z5Zhimm8C2yguu3JBd/HVTRWPppK2w7WqXjedhN1N0G0xhdNj+d2FAe8ZLPz7i4ZhWw5u7s5
TGnVJAdD4O4TecoNp00LaawPzwFhPQp43bjJZa0Lj0U9lGcg5TBsZfifix1NrUbG0CO5Mcf1
LJ5DNaEWLzRMPFI4caHp4jaWR30Yuuil70NYqUuZicUbI2SlLM6Vh9VatOMJh84jpARdcZXz
dsV6oIblgWCBYoCVzgzHiRZ9PfIzIKusZBsot2FiMEMeG0hc5Wxp1d/8g5V58i7IWt935gIw
IkzZXkCqp2/U2ZOQmz2xJN/WIvvoP97ksl/rQA/rFHD4SBMCAwEAAaOCAdAwggHMMB8GA1Ud
IwQYMBaAFGkAocchWPjgxRsgsArdp1G/E9nkMB0GA1UdDgQWBBSSsZj13ByPy4RueXQ8Zf9F
AG01zTAOBgNVHQ8BAf8EBAMCBaAwDAYDVR0TAQH/BAIwADAdBgNVHSUEFjAUBggrBgEFBQcD
BAYIKwYBBQUHAwIwPwYDVR0gBDgwNjA0BgsrBgEEAbIxAQICTzAlMCMGCCsGAQUFBwIBFhdo
dHRwczovL3NlY3RpZ28uY29tL0NQUzBCBgNVHR8EOzA5MDegNaAzhjFodHRwOi8vR0VBTlQu
Y3JsLnNlY3RpZ28uY29tL0dFQU5UUGVyc29uYWxDQTQuY3JsMHgGCCsGAQUFBwEBBGwwajA9
BggrBgEFBQcwAoYxaHR0cDovL0dFQU5ULmNydC5zZWN0aWdvLmNvbS9HRUFOVFBlcnNvbmFs
Q0E0LmNydDApBggrBgEFBQcwAYYdaHR0cDovL0dFQU5ULm9jc3Auc2VjdGlnby5jb20wTgYD
VR0RBEcwRYEVYWVzenRlckBtcGluYXQubXBnLmRlgRVhZXN6dGVyQG1waWJwYy5tcGcuZGWB
FWFlc3p0ZXJAbXBpbmF0Lm1wZy5kZTANBgkqhkiG9w0BAQwFAAOCAgEAMgeKjqVB9MB8cfE7
qw6zkgOq4CCZOQyZcnCQFb1OxSEyY6IwhI8sqq0x05yeiOgPqYc4IB5vpJ0+fkITEjAOieM8
1xCKjSB/+CqTNSf+LPSkH/5p1RD+4nXn4NvRX9sG037/JqMUUtJn/zyCOIqrCa7bEwqqzBj2
371hZuTCFXgrbfmaQxTk2gXRanR/WQH0BMEK9lc4PY+47mia+Ceg+U26zvhGEMVBKq19K5oG
K+H0gk6yf1kmFyBjOCG+Bi4ZfHyiEN58NemSM3UZoKG2krI0hoFws6NSeXc0PhFw5ae6CyMk
TB+FQoJWDFskcXJI3chu4b5HV2hdf1CfO4aiN0QkdUjq+kBUvD+av5l/2YgtiRtXZHGP6jW/
VKIRq1BQrMpbF13bBJigpfnVATKirrkB0fqKVaTJpUiZDuV6UpjRAME0CldySo/3mvRm588r
0HjOYDJNGKDnG8ppWWcySjWXaVZlAOO7b+0ejCoys6F/e/1DD0+uVOajUQV6dmMMpMsSPlj+
SirP9aBScCe9WhZZR7iaxJm88OE+piqSja3RApyWnoNLnm+P8OmV5inHfeTWWY3K3eBvMRG8
XPJGRyVYdgOew5VSCqhHZYSIFdK/aNYrbCeiX/CHtlWqNZe4+RmXgvHgl8ma/yERzPEIvzUS
+zauRms7WI6mS5IDkMQxggNtMIIDaQIBATBbMEYxCzAJBgNVBAYTAk5MMRkwFwYDVQQKExBH
RUFOVCBWZXJlbmlnaW5nMRwwGgYDVQQDExNHRUFOVCBQZXJzb25hbCBDQSA0AhEArntcS52c
KQYE3I5H60zgTTANBglghkgBZQMEAgEFAKCB5DAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcB
MBwGCSqGSIb3DQEJBTEPFw0yMzA0MTIxMjUzMjhaMC8GCSqGSIb3DQEJBDEiBCC0ZTsu6ulL
Dlbyr861yDI3PwgMoemxuzLytyeAl0stljB5BgkqhkiG9w0BCQ8xbDBqMAsGCWCGSAFlAwQB
KjALBglghkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMA4GCCqGSIb3DQMCAgIA
gDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggqhkiG9w0DAgIBKDANBgkqhkiG9w0BAQEF
AASCAgCVw4yhJUR2c5ZWW2TFaOPXXeFJ2feiLeTfWNH6FzapCArCU6fa2Csl9+YaCriuQlB2
SZ/RcwdRNOXvBluNGG2vVUR67fFbLzpMJBh3MamkRkTH7u+zTUn6zL18IJwLTshOXsXPIfRG
l4NduRTKs9SdV90o9b08jXUGQ2BVm0bGIvUsBPNnkTgBaCo09JE1ipiUla8C9RgswAio/ziF
v+6lk9Yqp/F7apAlc4t5Bgv1vTY1Qr4qtwfyUR8er+jhOvu723c8TXeOPEe2AKff8YYIRYT7
r4X3FSK7ShyyCOTeGsOJDLTgbDDLd03bMDGX/t0psDpfvkSc8XTRLfknzbx7XsBnmnTwcK4k
jVxJhYHgcw1lDFje5/qjDlJRf2dfjFGjVbphTIHMP7FseEWu05AuPjMDJ8AhQMQP5KbkcLG8
1UamAJEWhz+gBS7fc2l7SkiBgx9rDEYtQ2SlVYi8cd8XwWOAaEkeq6YOlvcuus43VOKL63wZ
oRwwDNadhTmV33Z6sO5qphpmJOfX67B8l6LcJN+8LPwQiUvmMDp4znTwXVuc795JK5TaTTmb
+M2CBU1QhX+1cQ7no/5M+NUVtLt7mDa8PZCEHmBep7i7ZooxdfF4JqzmR4vix4hjHQX7fgj/
Im97qaYjx1QAr+y75SMEegqJHZKj2UE0mYXdNuh9MQ==

--a3ClU/92GM1mAWoW--
