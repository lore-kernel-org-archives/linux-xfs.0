Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A30FBC433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Jan 2021 22:27:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F48C22E01
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Jan 2021 22:27:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726481AbhASW1x (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 Jan 2021 17:27:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728277AbhASW1s (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Jan 2021 17:27:48 -0500
Received: from buxtehude.debian.org (buxtehude.debian.org [IPv6:2607:f8f0:614:1::1274:39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5375DC061573
        for <linux-xfs@vger.kernel.org>; Tue, 19 Jan 2021 14:27:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=bugs.debian.org; s=smtpauto.buxtehude; h=Content-Type:Date:Reply-To:
        References:Message-ID:Subject:To:From:MIME-Version:Cc:
        Content-Transfer-Encoding:Content-ID:Content-Description:In-Reply-To;
        bh=/2qXGxK0/emipqu33nn5TZBWnkoLH1+2xYtovsmXPMo=; b=reZhzd5wvmVc25He5xOQ9rZN0j
        yCGtC8YvjIT4lbqQkDJF+oR8qqLk2m02LeAh48mMEYT2OSu7U7UH5jzzoER4XO2dT14M63M5yDAbN
        FqxG2qDO1ONy91534l/XVxdczEgN3fJUI8JXmDMTPVgSAFgM5HnK2U3VWQN+ertgPzkpuCwVH/ZrG
        PRy3wjLhukUHjfe9TCA5ws/nLi8UFQC4FElyeq7IuX9dHZke8J3emBXjhXrF07AcAKuvgLZtKBMYx
        dGqi8yd68ENMSfRhmA3G1RHBqFEeYVU6EedUEMpIGLS+GnInOCJU8Qf9ngvWW7T/lyu6+DfuuFvtc
        pFbRHl1A==;
Received: from debbugs by buxtehude.debian.org with local (Exim 4.92)
        (envelope-from <debbugs@buxtehude.debian.org>)
        id 1l1zSs-0001f6-OZ; Tue, 19 Jan 2021 22:27:06 +0000
MIME-Version: 1.0
X-Mailer: MIME-tools 5.509 (Entity 5.509)
X-Loop: owner@bugs.debian.org
From:   "Debian Bug Tracking System" <owner@bugs.debian.org>
To:     Bastian Germann <bastiangermann@fishpost.de>
Subject: Bug#979644: marked as done (xfsprogs: Cryptographically verify
 upstream tarball)
Message-ID: <handler.979644.D979644.16110950475311.ackdone@bugs.debian.org>
References: <E1l1zPx-0005hU-CQ@fasolo.debian.org>
 <a5fa6801-b6d6-eb21-d11d-29e419fe77c0@fishpost.de>
X-Debian-PR-Message: closed 979644
X-Debian-PR-Package: src:xfsprogs
X-Debian-PR-Source: xfsprogs
Reply-To: 979644@bugs.debian.org
Date:   Tue, 19 Jan 2021 22:27:06 +0000
Content-Type: multipart/mixed; boundary="----------=_1611095226-6387-0"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is a multi-part message in MIME format...

------------=_1611095226-6387-0
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

Your message dated Tue, 19 Jan 2021 22:24:05 +0000
with message-id <E1l1zPx-0005hU-CQ@fasolo.debian.org>
and subject line Bug#979644: fixed in xfsprogs 5.10.0-2
has caused the Debian Bug report #979644,
regarding xfsprogs: Cryptographically verify upstream tarball
to be marked as done.

This means that you claim that the problem has been dealt with.
If this is not the case it is now your responsibility to reopen the
Bug report if necessary, and/or fix the problem forthwith.

(NB: If you are a system administrator and have no idea what this
message is talking about, this may indicate a serious mail system
misconfiguration somewhere. Please contact owner@bugs.debian.org
immediately.)


--=20
979644: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D979644
Debian Bug Tracking System
Contact owner@bugs.debian.org with problems

------------=_1611095226-6387-0
Content-Type: message/rfc822
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

Received: (at submit) by bugs.debian.org; 9 Jan 2021 17:34:46 +0000
X-Spam-Checker-Version: SpamAssassin 3.4.2-bugs.debian.org_2005_01_02
	(2018-09-13) on buxtehude.debian.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=4.0 tests=BAYES_00,DIGITS_LETTERS,
	DKIM_SIGNED,DKIM_VALID,FVGT_m_MULTI_ODD,MURPHY_DRUGS_REL8,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,TXREP autolearn=no
	autolearn_force=no version=3.4.2-bugs.debian.org_2005_01_02
X-Spam-Bayes: score:0.0000 Tokens: new, 309; hammy, 150; neutral, 75; spammy,
	0. spammytokens: hammytokens:0.000-+--H*r:TLS1_3,
	0.000-+--UD:kernel.org, 0.000-+--tarballs, 0.000-+--H*u:78.0,
	0.000-+--www.kernel.org
Return-path: <bastiangermann@fishpost.de>
Received: from mail-wm1-x32a.google.com ([2a00:1450:4864:20::32a]:36382)
	by buxtehude.debian.org with esmtps (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
	(Exim 4.92)
	(envelope-from <bastiangermann@fishpost.de>)
	id 1kyI8T-0000Oq-Mt
	for submit@bugs.debian.org; Sat, 09 Jan 2021 17:34:46 +0000
Received: by mail-wm1-x32a.google.com with SMTP id y23so11142493wmi.1
        for <submit@bugs.debian.org>; Sat, 09 Jan 2021 09:34:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fishpost-de.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language;
        bh=5pYc4reLjSs2ksaJWJqZnw982dU3XIV78j7WQUsa6Ic=;
        b=1iUmWZD6zpE5kwAdz0qB1Kf2iowJdrPuYsz3COMPmDAfo5vfNXj22aNePQ1e+5YkZB
         UxSzNrNN3JnPLKJD51YDH9hMCYeB4y32n7xHRo/LwrMk57bBh1yQ+ZRIQGQ16+xjKgjO
         Uh/+hipA7MC2K44S89dM7YurdJ1mRkGlr34pC98r5+/fFU89vo8QbnmO5yiB72WgPAj6
         A4w2LjPkAnGWAtGxzFLErVUNO97K4jwpNM/hblulFNLJ4Cx77vGa0a9hc4UeZRcAJasd
         d4pbD7vDSDPu9VgUeL6J/PVBQp20fzuOauBvBaftB6h0WxCVncZDDDa0ROPiSx5H5VAR
         0Skg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language;
        bh=5pYc4reLjSs2ksaJWJqZnw982dU3XIV78j7WQUsa6Ic=;
        b=IUFAnbVV1mCnw2R3GKOxsTCgl7f0rdP61dt+Ja+Orvn2OO+fHHvtDyfdkJk+RACRaO
         /t/5YzDB8eaiec/hrOxclzCQkqx+Vy5KTGxAOlYMcLHMH+f7EvKqe6hbEVpvSLw8dvqp
         Q4xEfdLiZ0cldh5dpeg6b1E4U/Nm77NoH2LRWHLf64P1HSVHtnhCeJrD75qSEXTWIwBo
         3CRJ5RZDe7I/pGU2oEga2Z5ru77oxs9ol+37287oze1EpLMCi9wp/VlABTJtvhR1mhz0
         zfMhF2aHKZjSRu17I1oxQ/8jtrRMr1UNM0rDA8rLifazWyMPG3EEtubN3Wwnq4OW15c4
         toBg==
X-Gm-Message-State: AOAM532x6HBvVgTUh+AVds997VDzBzq/yfYBo+UjAsbpZAXFJ3gWFAxD
	GqeQyuBAEX1pBv5SoSPOImuIxlx6jKQgteYt
X-Google-Smtp-Source: ABdhPJwvJ8sIp5O51vS3qtg+IqKPHhTREnzv6Cc98xQ5gga8ykr5jMiGE+ARCrJjQFfhqCtuZVf6ZQ==
X-Received: by 2002:a1c:5402:: with SMTP id i2mr8206606wmb.12.1610213681980;
        Sat, 09 Jan 2021 09:34:41 -0800 (PST)
Received: from ?IPv6:2003:d0:6f35:5400:9d4a:a26f:7cc6:6e27? (p200300d06f3554009d4aa26f7cc66e27.dip0.t-ipconnect.de. [2003:d0:6f35:5400:9d4a:a26f:7cc6:6e27])
        by smtp.gmail.com with ESMTPSA id k1sm18034716wrn.46.2021.01.09.09.34.40
        for <submit@bugs.debian.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 09 Jan 2021 09:34:41 -0800 (PST)
To: submit@bugs.debian.org
From: Bastian Germann <bastiangermann@fishpost.de>
Subject: xfsprogs: Cryptographically verify upstream tarball
Message-ID: <a5fa6801-b6d6-eb21-d11d-29e419fe77c0@fishpost.de>
Date: Sat, 9 Jan 2021 18:34:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------11478B12A39390AF5093C45A"
Content-Language: de-DE-frami
Delivered-To: submit@bugs.debian.org

This is a multi-part message in MIME format.
--------------11478B12A39390AF5093C45A
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

Source: xfsprogs
Version: xfsprogs/5.6.0-1
Severity: wishlist

Upstream signs their tarballs. Please verify them. A patch is enclosed.

--------------11478B12A39390AF5093C45A
Content-Type: text/x-patch; charset=UTF-8;
 name="Cryptographically-verify-upstream-tarball.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="Cryptographically-verify-upstream-tarball.patch"

From: Bastian Germann <bastiangermann@fishpost.de>
Date: Sat, 9 Jan 2021 18:28:45 +0100
Subject: Cryptographically verify upstream tarball
---
diff --git a/debian/upstream/signing-key.asc b/debian/upstream/signing-key.asc
new file mode 100644
index 0000000..5a9ec9b
--- /dev/null
+++ b/debian/upstream/signing-key.asc
@@ -0,0 +1,63 @@
+-----BEGIN PGP PUBLIC KEY BLOCK-----
+
+mQINBE6x99QBEADMR+yNFBc1Y5avoUhzI/sdR9ANwznsNpiCtZlaO4pIWvqQJCjB
+zp96cpCsnQZV32nqJBYnDpBDITBqTa/EF+IrHx8gKq8TaSBLHUq2ju2gJJLfBoL7
+V3807PQcI18YzkF+WL05ODFQ2cemDhx5uLghHEeOxuGj+1AI+kh/FCzMedHc6k87
+Yu2ZuaWF+Gh1W2ix6hikRJmQvj5BEeAx7xKkyBhzdbNIbbjV/iGi9b26B/dNcyd5
+w2My2gxMtxaiP7q5b6GM2rsQklHP8FtWZiYO7jsg/qIppR1C6Zr5jK1GQlMUIclY
+FeBbKggJ9mSwXJH7MIftilGQ8KDvNuV5AbkronGCsEEHj2khs7GfVv4pmUUHf1MR
+IvV0x3WJkpmhuZaYg8AdJlyGKgp+TQ7B+wCjNTdVqMI1vDk2BS6Rg851ay7AypbC
+Px2w4d8jIkQEgNjACHVDU89PNKAjScK1aTnW+HNUqg9BliCvuX5g4z2jgJBs57lo
+TWAGe2Ve3cMy3VoQ40Wt3yKK0Eno8jfgzgb48wyycINZgnseMRhxc2c8hd51tftK
+LKhPj4c7uqjnBjrgOVaVBupGUmvLiePlnW56zJZ51BR5igWnILeOJ1ZIcf7KsaHy
+E6B1mG+XdmYtjDhjf3NAcoBWJuj8euxMB6TcQN2MrSXy5wSKaw40evooGwARAQAB
+tCVFcmljIFIuIFNhbmRlZW4gPHNhbmRlZW5Ac2FuZGVlbi5uZXQ+iQI4BBMBAgAi
+BQJOsffUAhsDBgsJCAcDAgYVCAIJCgsEFgIDAQIeAQIXgAAKCRAgrhaS4T3e4K8W
+D/9RxynMYm+vXF1lc1ldA4miH1Mcw2y+3RSU4QZA5SrRBz4NX1atqz3OEUpu7qAA
+ZUW9vp3MWEXeKrVR/yg0NZTOPe+2a7ZN0J+s7AF6xVjdEsjW4bOo5cmGMcpciyfr
+9WwZbOOUEWWZ08UkEFa6B+p4EKJ9eCOFeHITCkR3AA8uxtGBBAbFzm6wMmDegsvl
+d9bXv5RdfUptyElzqlIukPJRz3/p3bUSCT6mkW7rrvBUMwvGnaI2YVabJSLpd2xi
+Vs7+gnslOk35TAMLrJ0uo3Nt2bx3sFlDIr9E2RgKYpbNE39O35l8t+A3asqD8Dlq
+Dg+VgTuOKBny/bVeKFuKAJ0Bvy2EU+/GPj/rnNgWh0gCPiaKqRRkPriGwdAXQ2zk
+2oQUq0cfpOQm6oIKKgXEt+W/r0cxuWLAdxMsLYdzrARstfiMYLMnw6z6mGpptgTS
+Snemw1tODqe9+++Z6yM8JA1RIyCVRlGx4dBh+vtQsFzCJfgIZxmF0rWKgW2aAOHb
+zNHG+UUODLK0IpOhUYTcgyjlvFM3tFwVjy0z/wF8ebmHkzeTMKJ64nPClwwfRfHz
+6KlgGlzEefNtZoHN7iR7uh282CpQ24NUChS2ORSd85Jt5TwxOfgSrEO9cC7rOeh1
+8fNShCRrTG6WBdxXmxBn/e49nI2KHhMSVxut37YoWtqIu7QkRXJpYyBSLiBTYW5k
+ZWVuIDxzYW5kZWVuQHJlZGhhdC5jb20+iQI4BBMBAgAiBQJOsq5eAhsDBgsJCAcD
+AgYVCAIJCgsEFgIDAQIeAQIXgAAKCRAgrhaS4T3e4IdpD/wOgkZiBdjErbXm8gZP
+uj6ceO3LfinJqWKJMHyPYmoUj4kPi5pgWRPjzGHrBPvPpbEogL88+mBF7H1jJRsx
+4qohO+ndsUjmFTztq1+8ZeE9iffMmZWK4zA5kOoKRXtGQaVZeOQhVGJAWnrpRDLK
+c2mCx+sxrD44H1ScmJ1veGVy1nK0k4sQTyXA7ZOI+o622NyvHlRYpivkUqugqmYF
+GfrmgwP8CeJB62LrzN0D27B0K/22EjZFQBcYJRumuAkieMO9P3U/RRW+48499J5m
+gZgxXLgvsc3nKXH5Wi77hWsrgSbJTKeHm2i/H4Jb57VrEGTPN+tQpI7fNrqaNiUW
+Ik65RPV4khBrMVtxKXRU971JiJYGNP16OTxr98ksHBbnEVJNUPY/mV+IAml+bB6U
+DNN1E2g8eIxXRqji5009YX6zEGdxIs1W50FvRzdLJ5vZQ+T+jtXccim2aXr31gX8
+HUN+UVwWyCg5pmZ8CRiYGJeQc4eQ5U9Ce6DFTs3RFWIqVsfNsAah1VuCNbT7p8oK
+2DvozZ/gS8EQjmESZuQQDcGMdDL1pZtzLdzpJFtqW1/gtz+aAHMa35WsNx3hAYvy
+mJMoMaL1pfdyC07FtN0dGjXCOm0nWEf+vKS+BC3cexv0i22h39vBc81BY0bzeeZw
+aDHjzhaNTuirZF10OBm11Xm3b7kCDQROsffUARAA0DrUifTrXQzqxO8aiQOC5p9T
+z25Np/Tfpv1rofOwL8VPBMvJX4P5l1V2yd70MZRUVgjmCydEyxLJ6G2YyHO2IZTE
+ajUY0Up+b3ErOpLpZwhvgWatjifpj6bBSKuDXeThqFdkphF5kAmgfVAIkan5SxWK
+3+S0V2F/oxstIViBhMhDwI6XsRlnVBoLLYcEilxA2FlRUS7MOZGmRJkRtdGD5koV
+ZSM6xVZQSmfEBaYQ/WJBGJQdPy94nnlAVn3lH3+N7pXvNUuCGV+t4YUt3tLcRuIp
+YBCOWlc7bpgeCps5Xa0dIZgJ8Louu6OBJ5vVXjPxTlkFdT0S0/uerCG51u8p6sGR
+LnUeAUGkQfIUqGUjW2rHaXgWNvzOV6i3tf9YaiXKl3avFaNW1kKBs0T5M1cnlWZU
+Utl6k04lz5OjoNY9J/bGyV3DSlkblXRMK87iLYQSrcV6cFz9PRl4vW1LGff3xRQH
+ngeN5fPxze8X5NE3hb+SSwyMSEqJxhVTXJVfQWWW0dQxP7HNwqmOWYF/6m+1gK/Y
+2gY3jAQnsWTru4RVTZGnKwEPmOCpSUvsTRXsVHgsWJ70qd0yOSjWuiv4b8vmD3+Q
+FgyvCBxPMdP3xsxN5etheLMOgRwWpLn6yNFq/xtgs+ECgG+gR78yXQyA7iCs5tFs
+2OrMqV5juSMGmn0kxJUAEQEAAYkCHwQYAQIACQUCTrH31AIbDAAKCRAgrhaS4T3e
+4BKwD/0ZOOmUNOZCSOLAMjZx3mtYtjYgfUNKi0kiYPveGoRWTqbis8UitPtNrG4X
+xgzLOijSdOEzQwkdOIp/QnZhGNssMejCnsluK0GQd+RkFVWNmcQT78hBeGcnEMAX
+ZKq7bkIKzvc06GFmkMbX/gAl6DiNGv0UNAX+5FYh+ucCJZSyAp3sA+9/LKjxnTed
+X0aygXA6rkpX0Y0FvN/9dfm47+LGq7WAqBOyYTU3E6/+Z72bZoG/cG7ANLxcPool
+LOrU43oqFnD8QwcN56y4VfFj3/jDF2MX3xu4v2OjglVjMEYHTCxP3mpxesGHuqOi
+t/FR+mF0MP9JGfj6x+bj/9JMBtCW1bY/aPeMdPGTJvXjGtOVYblGZrSjXRn5++Uu
+y36CvkcrjuziSDG+JEexGxczWwN4mrOQWhMT5Jyb+18CO+CWxJfHaYXiLEW7dI1A
+ynL4jjn4W0MSiXpWDUw+fsBOPk6ah10C4+R1Jc7dyUsKksMfvvhRX1hTIXhth85H
+16706bneTayZBhlZ/hK18uqTX+s0onG/m1F3vYvdlE4p2ts1mmixMF7KajN9/E5R
+QtiSArvKTbfsB6Two4MthIuLuf+M0mI4gPl9SPlffWCYVPhaU9o83y1KFbD/+lh1
+pjP7bEu/YudBvz7F2Myjh4/9GUAijrCTNeDTDAgvIJDjXuLXpA==
+=El1H
+-----END PGP PUBLIC KEY BLOCK-----
diff --git a/debian/watch b/debian/watch
index 88f6a0f..ecf0648 100644
--- a/debian/watch
+++ b/debian/watch
@@ -1,3 +1,3 @@
 version=3
-opts=uversionmangle=s/(\d)[_\.\-\+]?((RC|rc|pre|dev|beta|alpha)\d*)$/$1~$2/ \
+opts=pgpsigurlmangle=s/xz$/sign/,decompress,uversionmangle=s/(\d)[_\.\-\+]?((RC|rc|pre|dev|beta|alpha)\d*)$/$1~$2/ \
 https://www.kernel.org/pub/linux/utils/fs/xfs/xfsprogs/xfsprogs-(.+)\.tar\.xz

--------------11478B12A39390AF5093C45A--

------------=_1611095226-6387-0
Content-Type: message/rfc822
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

Received: (at 979644-close) by bugs.debian.org; 19 Jan 2021 22:24:07 +0000
X-Spam-Checker-Version: SpamAssassin 3.4.2-bugs.debian.org_2005_01_02
	(2018-09-13) on buxtehude.debian.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.1 required=4.0 tests=BAYES_00,DIGITS_LETTERS,
	FOURLA,FVGT_m_MULTI_ODD,HAS_BUG_NUMBER,MD5_SHA1_SUM,PGPSIGNATURE,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,TXREP autolearn=ham
	autolearn_force=no version=3.4.2-bugs.debian.org_2005_01_02
X-Spam-Bayes: score:0.0000 Tokens: new, 99; hammy, 150; neutral, 137; spammy,
	0. spammytokens: hammytokens:0.000-+--HX-Debian:DAK,
	0.000-+--H*rp:D*ftp-master.debian.org, 0.000-+--HX-DAK:process-upload,
	0.000-+--Hx-spam-relays-external:sk:envelop, 0.000-+--H*r:138.16.160
Return-path: <envelope@ftp-master.debian.org>
Received: from mailly.debian.org ([2001:41b8:202:deb:6564:a62:52c3:4b72]:57062)
	from C=NA,ST=NA,L=Ankh Morpork,O=Debian SMTP,OU=Debian SMTP CA,CN=mailly.debian.org,EMAIL=hostmaster@mailly.debian.org (verified)
	by buxtehude.debian.org with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <envelope@ftp-master.debian.org>)
	id 1l1zPz-0001NM-QJ
	for 979644-close@bugs.debian.org; Tue, 19 Jan 2021 22:24:07 +0000
Received: from fasolo.debian.org ([138.16.160.17]:42980)
	from C=NA,ST=NA,L=Ankh Morpork,O=Debian SMTP,OU=Debian SMTP CA,CN=fasolo.debian.org,EMAIL=hostmaster@fasolo.debian.org (verified)
	by mailly.debian.org with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <envelope@ftp-master.debian.org>)
	id 1l1zPy-0002jo-BT; Tue, 19 Jan 2021 22:24:06 +0000
Received: from dak by fasolo.debian.org with local (Exim 4.92)
	(envelope-from <envelope@ftp-master.debian.org>)
	id 1l1zPx-0005hU-CQ; Tue, 19 Jan 2021 22:24:05 +0000
From: Debian FTP Masters <ftpmaster@ftp-master.debian.org>
Reply-To: Bastian Germann <bastiangermann@fishpost.de>
To: 979644-close@bugs.debian.org
X-DAK: dak process-upload
X-Debian: DAK
X-Debian-Package: xfsprogs
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: Bug#979644: fixed in xfsprogs 5.10.0-2
Message-Id: <E1l1zPx-0005hU-CQ@fasolo.debian.org>
Date: Tue, 19 Jan 2021 22:24:05 +0000

Source: xfsprogs
Source-Version: 5.10.0-2
Done: Bastian Germann <bastiangermann@fishpost.de>

We believe that the bug you reported is fixed in the latest version of
xfsprogs, which is due to be installed in the Debian FTP archive.

A summary of the changes between this version and the previous one is
attached.

Thank you for reporting the bug, which will now be closed.  If you
have further comments please address them to 979644@bugs.debian.org,
and the maintainer will reopen the bug report if appropriate.

Debian distribution maintenance software
pp.
Bastian Germann <bastiangermann@fishpost.de> (supplier of updated xfsprogs package)

(This message was generated automatically at their request; if you
believe that there is a problem with it please contact the archive
administrators by mailing ftpmaster@ftp-master.debian.org)


-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 1.8
Date: Thu, 14 Jan 2021 18:59:14 +0100
Source: xfsprogs
Architecture: source
Version: 5.10.0-2
Distribution: unstable
Urgency: low
Maintainer: XFS Development Team <linux-xfs@vger.kernel.org>
Changed-By: Bastian Germann <bastiangermann@fishpost.de>
Closes: 979644 979653
Changes:
 xfsprogs (5.10.0-2) unstable; urgency=low
 .
   * Team upload
   * debian: cryptographically verify upstream tarball (Closes: #979644)
   * debian: remove dependency on essential util-linux
   * debian: remove "Priority: extra"
   * debian: use Package-Type over its predecessor
   * debian: add missing copyright info (Closes: #979653)
Checksums-Sha1:
 9c7923ea5735242a29b8481cbd38059c850433b9 2034 xfsprogs_5.10.0-2.dsc
 9e5cbf9b3a561c3b9b391f0b1330bcb4b3537d38 1273332 xfsprogs_5.10.0.orig.tar.xz
 7240aa6c2fb907b9f1aeec8ae6d19fb8c62c1585 13792 xfsprogs_5.10.0-2.debian.tar.xz
 87001ed58e1229bb8b9c7cc4348b5e07646675ef 6593 xfsprogs_5.10.0-2_source.buildinfo
Checksums-Sha256:
 d4b995161ecfc754895c3a91931db9787fffc924fbc2a5cd51abb11a28ac1522 2034 xfsprogs_5.10.0-2.dsc
 e04017e46d43e4d54b9a560fd7cea922520f8f6ef882404969d20cd4e5c790e9 1273332 xfsprogs_5.10.0.orig.tar.xz
 3f144a529ec274ffd720ad70c347b294c9a787868b2119ecacbf0c16bcb642f1 13792 xfsprogs_5.10.0-2.debian.tar.xz
 a022f266d04946b600fdb12815a4197d4dbb70ae8bfe92e5c682803bba9ac42d 6593 xfsprogs_5.10.0-2_source.buildinfo
Files:
 49fad22f902144635cd5a7c06de1fb1e 2034 admin optional xfsprogs_5.10.0-2.dsc
 f4156af67a0e247833be88efaa2869f9 1273332 admin optional xfsprogs_5.10.0.orig.tar.xz
 6bb054391ad11b6d23d883a907e099be 13792 admin optional xfsprogs_5.10.0-2.debian.tar.xz
 853ed7390e20376455676cf65ba4137d 6593 admin optional xfsprogs_5.10.0-2_source.buildinfo

-----BEGIN PGP SIGNATURE-----

iQHPBAEBCgA5FiEEQGIgyLhVKAI3jM5BH1x6i0VWQxQFAmAHV+cbHGJhc3RpYW5n
ZXJtYW5uQGZpc2hwb3N0LmRlAAoJEB9ceotFVkMUZCIL+wXFyjxnBr2VGlTj+BVU
taQwxuvEZoFwxvNwZ4Z5s38FBi6DzPWLF2jxCv4M0UTOpDPstg5WXebhfOnOdp4D
0WW8G39jMIB2J+b0OQEGcMKdwuXKYKfDdBdOa+lesUoUU8AZEazS/whzMa7FD7wB
/av/28PvYdWFK/ddERfujPIa6BtoIE2QszggOCHqCbUt3egQLCTxA+2qPR+f5Nrs
VT/xgDrkkHC9ypkU8kypv4XhetHKwwxDyp+4PLja0OSnuH6/KzmiV8gI/Hq4Y4/l
lYzXiWWjz5ofEHc3haGxqsKxabyRT6h31INdxfKjFhnFVrEyh3l+KjJL4AXcn8wH
fB/DL2uquJkWBJ+N7xD/UYvDylwNaqnkyYOMCy+JyKE1lJZv5AfAGlsZ3VAnOeGT
Rn8e7XF+4lPWsckPZ+YZWqGDmLbRxAeg5xGQ2iFKFPfwq0grKjARF+33JWkHR3Jk
O/MWldWzIuogu77fsZbPlRPgG7dj8eA2pjscQJOXo/yb6g==
=IDLF
-----END PGP SIGNATURE-----
------------=_1611095226-6387-0--
