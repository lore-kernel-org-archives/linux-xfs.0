Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBCF0C77B6E
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Apr 2023 07:53:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229486AbjDLHxy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 Apr 2023 03:53:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbjDLHxy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Apr 2023 03:53:54 -0400
X-Greylist: delayed 1935 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 12 Apr 2023 00:53:51 PDT
Received: from tmailer.gwdg.de (tmailer.gwdg.de [134.76.10.23])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9D1CA0
        for <linux-xfs@vger.kernel.org>; Wed, 12 Apr 2023 00:53:51 -0700 (PDT)
Received: from excmbx-12.um.gwdg.de ([134.76.9.221] helo=email.gwdg.de)
        by mailer.gwdg.de with esmtp (GWDG Mailer)
        (envelope-from <Ansgar.Esztermann@mpinat.mpg.de>)
        id 1pmUnN-000D4t-Cu
        for linux-xfs@vger.kernel.org; Wed, 12 Apr 2023 09:21:34 +0200
Received: from aeszter.mpibpc.intern (10.250.9.199) by EXCMBX-12.um.gwdg.de
 (134.76.9.221) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P521) id 15.1.2507.23; Wed, 12
 Apr 2023 09:21:34 +0200
Date:   Wed, 12 Apr 2023 09:21:32 +0200
From:   Ansgar Esztermann-Kirchner <aeszter@mpinat.mpg.de>
To:     <linux-xfs@vger.kernel.org>
Subject: Replacing the external log device
Message-ID: <ZDZb/PtvFlyIMKDG@aeszter.mpibpc.intern>
Mail-Followup-To: linux-xfs@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature";
        micalg=sha-256; boundary="dq0mgOiqafgsOM6e"
Content-Disposition: inline
X-Originating-IP: [10.250.9.199]
X-ClientProxiedBy: EXCMBX-12.um.gwdg.de (134.76.9.221) To EXCMBX-12.um.gwdg.de
 (134.76.9.221)
X-Virus-Scanned: (clean) by clamav
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

--dq0mgOiqafgsOM6e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello List,

what should I expect when I replace the device that contains my xfs
log? Is there a specific procedure to follow? Also, did the expected
behaviour change at some point (in kernel history)?

Some background:
When I joined my current employer in 2006, I performed some benchmarks
to see which FS would provide the best performace for our workload:
multiple NFS clients appending to large (multi GB) files. XFS was the
clear winner, so since then, we have several dozen workstations with
XFS on mdraid (with LVM inbetween). For performance reasons, we keep=20
the log on a partion of the SSD that also holds the OS.
In all those years, the only data loss I can remember was caused by a
flaky controller that threw out disks from a RAID6 faster than they=20
could be rebuilt.

When a user leaves us but their data should still be kept online, we
move the HDDs to a disk array connected to a special fileserver. The
workstation can then get a fresh install and be used for someone else.
On the fileserver, for every set of disks addedm we create a new LV=20
in a VG dedicated to XFS logs and use that to mount the FS.
That, too, has never posed any problems (except for a duplicate UUID at
some point, but that was easily fixed with xfs_db).

However, I've been bitten by a nasty problem twice in recent weeks: in
the first instance, I wanted to replace a bunch of disks in a machine
(something like 4x10TB to 4x16TB). Usually, we do that by setting up a
new machine, rsyncing all the data, and then swap the machines. In
this instance, I refrained from swapping the machines (due to lack of
hardware), and merely swapped the disks. Initially, the kernel refused
to mount the new disks (this was expected: the UUID of the log was
incorrect, as I only swapped the HDDs, not the log device). I called
xfs_repair to fix that. xfs_repair completed successfully, and the=20
only modification reported was reformatting the log. However, the
kernel still refused to mount the file system ("structure needs
cleaning"), and a second run of xfs_repair reported hundreds of
problems. It managed to repair them all, but afterwards, the file
system was empty.  I started over, this time calling xfs_repair -L,
but the results were the same.
The hardware, kernel version, and Linux distribution were exactly the
same on both machines.=20
At the time, I thought maybe there was a strange bug in that (quite
old) kernel (4.12.14 from opensuse 15.1), so I resorted to waiting for
new hardware and setting up a fresh machine.

Yesterday, I did a Linux upgrade for a different user. After a clean
shutdown, I wiped the SSD (including the XFS log) and re-imaged it
with an up-to-date opensuse install. Afterwards, everything went as
described above.=20

I find this extremely puzzling (especially since we've been moving
disks like this to our file server more than a dozen times, all without
any problems, and I fail to see what is different there).

I'd be happy for an explanation of what can happen to damage the FS in
this scenario -- just out of curiosity -- but of course, any steps I
can take to keep the FS intact during this procedure are also very
welcome.

Thank you,

A.
--=20
Ansgar Esztermann
Sysadmin Dep. Theoretical and Computational Biophysics
https://www.mpinat.mpg.de/person/11315/3883774

--dq0mgOiqafgsOM6e
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
MBwGCSqGSIb3DQEJBTEPFw0yMzA0MTIwNzIxMzJaMC8GCSqGSIb3DQEJBDEiBCC23dOCtlZN
Ev3oXlK5HS2hN4OCfcZ7WS004Z9arRsVHjB5BgkqhkiG9w0BCQ8xbDBqMAsGCWCGSAFlAwQB
KjALBglghkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMA4GCCqGSIb3DQMCAgIA
gDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggqhkiG9w0DAgIBKDANBgkqhkiG9w0BAQEF
AASCAgAN7LHHAiwjqFRDeGdvDG+YChtCzu4/Cub2MDeo32CtaAT83J2wiSXx7BDSfkwVTPzX
00pCOB+9gI3S++fOJeGQU5ksA7Fggo2/Nlu6DPlymOsW/wtmVhsJjXV7ZrQT2rxWujM822Ee
qgLibPB57zKzeNI8dP5whSeSccIcF3O8Fm+UqoCkiZ8An7iW6zJwtsRiJvJj0MxzO+5Tiw8O
NrEFXOuf6YGP+kVxW5FPr+cwg2IjH5i/qF9SfSbViGezjZNYzE9DzPTQcZvGQ3R1Gw0eO3xF
05aApScLiPRiS+pfJbzJNvRAp/96IC62GcFWHMia8oe/IpSL6DlCzwxUTdKIcXVDOwrG2WH8
6AMzxQUHc6yRqm97ViDDO1TOUJDIWvi8CFlYzxDA+DQ+q4vh9SrHYOuDTuPjC3E3MxjoNpDp
Zn1ImknZLfGn1npWyLeo1bZfRZuL7JfY9B8DpCc+8KAT7ta5wxvEd+RU5qgtCRNsV1RjoZMh
v2N7zivdaFzlxXtSN6DmDcjPibMSsg4O3R6hxHnO9ViK4Di+N+ehmC1ilr/HnaFr6GXeX5jP
pr+2tmFkFuYQcDqjANTx6lqHnuu5it+f19eskULFnY0irdh2WLrkdMxSakEjiDq2A0d27Z46
Iq6g10Xlc5vbvhcZk2q3Hw/SrhO4feNGQD9P1wgWGg==

--dq0mgOiqafgsOM6e--
