Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=103.168.172.136
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792856249;
	b=rNvVgSFw8yvmQoRhhd2JjFKlzNY14mA7bLQl3wR6NXPS5jYNzt0FOVi9HjFyyU0tfQBK
	 hQZj+G9CAfZkD6LFROuyIF1iuoN0BbVD6V8j5PxG7xjhFNfg+TchcADqY2af8zQamqnCy
	 ArGIiOtoV3H7gOOkyGIOVXG0iItcmwdDoU+SOQ57T1AhwOkGHdU+9Bw+LeWGtskykysOU
	 musAkg4Et3yvxqPRrd2y59bX1E7iLmFa3bCXsfwsUECRYitEuIdEShbBAVE1JNo8adX7I
	 2kuH+Nfm2TWuIVaeGI4qiq1bc9yzSOBMGrlZzpRcpnyMGOqM0qxkKYKmmGOItR467Vw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792856249;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:Content-Type:Message-ID:Date:MIME-Version:User-Agent:Subject:
	 To:References:Content-Language:From:In-Reply-To;
	bh=wBlR61uGVZhpFY4QgzmkvJF2Tcsuksg7BEAOwMBl1FM=;
	b=vrjilWg7HdCRjwf5MjHZVxQYaBPnMTo3cFu9sYCh1p5KjM+oCW9mjG11MCIhF31jjz4d
	 RITSJbBMKk9XdSDjpUrurd0dD8AVmfYqmEj6eBnARVCK1mV5jZgqyltfIpBtMXkw/k8K5
	 lWwh5jJWpJqpFq77mT/BPa0c6NeRkpyYLTEAk8BvgJpUWxF5g6+AE2lFNUlZeUWGE1ZCP
	 BP2e3qmE06mVUqh/+e9vzLg0TjWiQ7WH8PlEsPVJPp+jyldJOtKPjYkrj5W4hsr822lN4
	 X6zUMmM9oTa+Cg3KAwX9/l2+dfjl6uWF+KNG8u6+pw3LUSXBmuxmyb3nHkfMRiW8kXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=sandeen.net;
	spf=pass smtp.mailfrom=sandeen.net;
	dkim=pass header.d=sandeen.net header.i=@sandeen.net header.a=rsa-sha256 header.s=fm2 header.b=tPkMOf03;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=OMvDAnJv;
	arc=none smtp.remote-ip=103.168.172.136
Received: from flow-a1-smtp.messagingengine.com (flow-a1-smtp.messagingengine.com [103.168.172.136])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C5BA606A31A
	for <linux-xfs@vger.kernel.org>; Sat, 24 Oct 2026 15:37:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4C5BA606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandeen.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sandeen.net header.i=@sandeen.net header.a=rsa-sha256 header.s=fm2 header.b=tPkMOf03;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=OMvDAnJv
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailflow.phl.internal (Postfix) with ESMTP id 448D113804F9
	for <linux-xfs@vger.kernel.org>; Sat, 24 Oct 2026 11:37:27 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Sat, 24 Oct 2026 11:37:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sandeen.net; h=
	cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm2; t=1792856247; x=1792863447; bh=wBlR61uGVZ
	hpFY4QgzmkvJF2Tcsuksg7BEAOwMBl1FM=; b=tPkMOf03dVpNrQWwXlaTN/BRQo
	hzuBr92feyP3pwb8IQ/RWwuNU9CXo28DmW49cfXa6IoyRtxfhg73mtgwZDnqXT3J
	lb6oj7EG3NnN7TsDqTWj1K/dQ3X09zwKkKm1MLfTOyzshtqpLMFXaKdkXNxOAzO8
	hvMEJQySrDW3sNywpWjRhPWm2wE+NIwc1060oP7IQRJxWCrxoZCbBrpHbh+05p33
	5ig2IPlzZti/5g93lh+rSA8nPdDcoIVdmcU1cyY6iImismEGeizi1SUPD0mLV3jQ
	JkYJvoMtghlx6Z4GG3G1BPHPKo98QAPSQCPi+7qPZoaVdA9zNEZlMzaUJlYA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1792856247; x=1792863447; bh=wBlR61uGVZhpFY4QgzmkvJF2Tcsuksg7BEA
	OwMBl1FM=; b=OMvDAnJvOxDfOv2gjnK+oMosBcfGogwOh2CvD9KLK7UOtBrrslk
	L92VdMkg9siK3hBJC1gyxacWpZLZ/OSmDBbemU8Up4/WmfC35y8Vmc2SGB2idVrL
	qubiwXZSdIegEfTfdUVg0Wwtrh4CPnuKOk81beLzKqCogUriHAKYZJ2MiSQLbvcr
	bewc2Md1ZZtCyfgeJK8NkJN/92pYhthDB4iAexW6jpla3jOUhZHoAQwUV7OJB3RL
	g1cv73jTahCXEO4JpHIgo02cJKl4KlfeGdJAPFZSr0AvVsFKA/wiYCV0K5KdZ9qg
	EBLzB9eIWvYGZGQ4PtXKPeFSUqodSshMdfw==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-07;
	repo=github.com/dkim2wg/interop; date=2026-10-18; sw=lmtpprox;
	action=sign d=sandeen.net a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1792856247; d=sandeen.net;
	mf=PHNhbmRlZW5Ac2FuZGVlbi5uZXQ+;
	rt=PGxpbnV4LXhmc0B2Z2VyLmtlcm5lbC5vcmc+;
	s=fm2:rsa-sha256:tSOUSsu7rF1NMivxWtJUfbq6MjhUCNl0k4jdXjyzj7vsmK/
	tZz7UrntlDaARAIAZeoCtLbqdex0DG0zYI59kxmk7RqLHmr56BjIECW8T5T45Kep
	LaYcpNjQdyTLwcjV/V71IlnHdEzMc76iU1g1QQojxOrcayGoJrXnxnnBXvfDAgr+
	vn41lnruBJE2uFmQ7f1EAAHEd7EQZJoQelmg5QujlrRsPqren2Xce/E7E6rItJ1w
	lVljWyCq2O162RSygng+bFnBt/v3PSNBEjkVz91XbBQYd1+aESGtm4Dee8iiTdlx
	g1S5iD74Us9U8DGrUKL2wT/+aJ4PROT8ipDfJwA==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-07;
	repo=github.com/dkim2wg/interop; date=2026-10-18; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=content-language,content-type,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,subject,to,
	user-agent;
Message-Instance: m=1; h=sha256:NAAJVV+Ffrz/Jr/2eSLLYFOBlP2EWRaZAguI7VQUUhA=:HeeN6MJyoufttSZjYOfGVI2WrWai5MVcPI9HA2yBzwc=;
X-ME-Sender: <xms:t9DcapT5lyWpbV2v2zWK4y-uOhBqyN744mTgPi2ZYMkXZOIdLCLwtw>
    <xme:t9DcaptQAJ_OWE_xoFZH6y8mzqd6-vaWiD7fzPX8UGrsYZcd82GVWuoqYVvMPngIF
    0FMzGzOyurWLWFqzujTiQer6FsZ8OdGbK6nGCiyZ5A2Lh7qZXYWEvY>
X-ME-Received: <xmr:t9Dcakf_kzBiXYParIDXeZ-lwwB20pF7W00sk5r2QZg_qnu4WPuHQ4esNSQW1kGplY_32M31XGDiu_nsiLgI4e1CWTOcOQ>
X-ME-Proxy-Cause: dmFkZTFZSso2OE2txcZnbycRMRs3Az/kTa/QcUbcxGGuxZAafEKCeZO86mS70xsjKtoqY7
    giQSaY1UAvD/RCHsWoOQHi0tIGgNFQGjIc8IFgd3bOZHKXsI6AySRmsyMU7NB+bltaTUry
    WM5/scVR2neQKQqHK3lh79jM4vNtTJi2OAfXFgFc0LLv4EyQlKRlOoWXAlZ1j/Qv7n5AOn
    YbphPs8HhuLkGuvLGIRKetILDOpeL7g3teqvblOePdgrCPtI26TR+c2gCYRl9Hk7xCoqno
    54bmeLmZTe3URhkyytSlBe+wOur+7QRUtSKMjSTo/q+5KaU/Z9zXCSM0BTB4wahvMnoqUg
    au+pvMBrcqT8MG01wgoLupiAH06SD67zsn7x04o3fRYIYaDtGmUjLLEXxJMdRJVvBG1nRe
    WTOAzmONlNSClh32cBSKX2MnteouOfGCQMA/W5nwq6iEj60R8gOdSzXU6UsvZh79OY0ksR
    qq7DZAxyhnyLabdL/hJFv3KqvcyY1jJ40GUMQcIclE9JRaqoul46ttTZfqtnnHLFaG1tkn
    4xfHQROntGwK4p9FDvUYZdOYtJPA8TUfClki+e/vjGCqCow3HRRLU1DXVLcS75E6+UXkvR
    i7acSh0arQ8dLA52J2EbB5u3BZioZ0qbDx4cX+bOx//wlgiZ7slwx9H4NXuA
X-ME-Proxy: <xmx:t9DcamL8RvY-OsViEB-EEhZ5cqUUVpoecKK_3Ujxvh-AlsV-omud_A>
    <xmx:t9DcaiZ3dupX9Tv98dmfL0rDE0sRjDZ_20zHFikysJh0-n1Af3hCFg>
    <xmx:t9DcahvML9DHPL-SB8_Q5Z7ASxQrw17RLOgh6bW023zDSIpSEd55kQ>
    <xmx:t9DcavsynTfir2rZ0-b9SuRItwbWRDRHopdwnSZeMs6itsctfxyz2w>
    <xmx:t9DcalTiBS2IXA1RdFYUnAy0QhR0tykignXrKMI7qkRTLg9l1HXlBSpp>
Feedback-ID: i2b59495a:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA for
 <linux-xfs@vger.kernel.org>; Sat, 24 Oct 2026 11:37:26 -0400 (EDT)
Content-Type: multipart/mixed; boundary="------------2km7M7M3B0fs228B1htiZyCX"
Message-ID: <2d24d2dd-b8e7-4da3-867a-a62b0dfc95f0@sandeen.net>
Date: Sat, 24 Oct 2026 10:37:26 -0500
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xfs: validate btree block level on read
To: linux-xfs@vger.kernel.org
References: <20260731120344.558808-1-david.lee@trailofbits.com>
 <am0voArOlA31WBC3@dread>
 <CAC_etQGTnVV-Jd0waUMfT=8-JtSHxnrQq9jJRDQBisX+1EHWWg@mail.gmail.com>
 <an-LhCZLN06ajjI5@dread>
 <179278367083.68413.17147250369624243185.xfs-lists-plaintext-resend@trailofbits.com>
Content-Language: en-US
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <179278367083.68413.17147250369624243185.xfs-lists-plaintext-resend@trailofbits.com>

This is a multi-part message in MIME format.
--------------2km7M7M3B0fs228B1htiZyCX
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/23/26 2:27 PM, David Lee wrote:
> Hi Dave,
> 
> Thanks for the review. I reproduced the issue on October 23, 2026 with
> the unchanged original PoC on mainline commit
> 734bef548a96e8774d6eef5dfa2026c6edc4e80b
> (7.3.0-package1-2-20-xfs-mainline).
> 
> The cause is a wrong-level sibling: a level-1 node's left-sibling
> pointer references a checksum-valid level-0 RTRMAP leaf with 100
> records. The leaf verifier accepts that count because its limit is 167.
> But lshift uses the internal-node layout, whose limit is 83. Its
> equality check misses 100, increments the count to 101, and copies a
> 40-byte key pair at offset 4072, overrunning the 4 KiB buffer by 16
> bytes.
> 
> The log reports the invalid write as a KASAN use-after-free in
> xfs_btree_lshift through inodegc. It introduces out-of-bounds key write
> described above.
> 
> Attached poc.c, the detailed report.txt, and full_kasan.log.

This is a start. You still have not addressed the attribution problems
mentioned, and for any future submissions, it's preferable to have an
actual filesystem image, not an array of bytes in a C file, because
standard tools can be used to inspect and analyze the image. We can
of course modify the C code to leave the image in place, but it's several
extra steps for anyone who wants to look at it.

For automated(?) submissions like this, doing everything possible to
reduce friction and overhead for the scarce human developer resources
is going to be a win.

I've attached the fs image here; AFAICT the repro is to mount the
image, unlink the single file in it, and sync() then wait for GC.

Also just as a general note, this sort of corrupted image is generally
not considered to be a security issue even if it does describe a bug.
Mount is a privileged operation, and even udisks helper workarounds
require physical access to the machine.

(I haven't looked closely at the propoosed patch in the context of
Dave's initial review, just comments on the submission, style, and
supporting materials here.) 

-Eric

> If this looks like the right direction, I'll send v2 with the corrected
> tags.
> 
> For reference, here is the original mail thread:
> https://lore.kernel.org/linux-xfs/20260731120344.558808-1-david.lee@trailofbits.com/
> 
> Best regards,
> David

--------------2km7M7M3B0fs228B1htiZyCX
Content-Type: application/x-bzip2; name="rtrmap-poc.img.bz2"
Content-Disposition: attachment; filename="rtrmap-poc.img.bz2"
Content-Transfer-Encoding: base64

QlpoOTFBWSZTWUxMUI4FfSR//////f/1933//7+7V937313/////////////////////0AQS
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
qg0qqjG//9UqVBGAATAAAAARgAAAAAAAAACYTAAAAAAAAAAAAAAAAAABMAgjVVFM///VKqUw
mAARgAAAABMAAAAAAAABMJkwAmAAAAAAAAAAAAAAAJgAE0P9VN/HEMRxLE/5YpiuGqq/53tS
VJVSYlJKkqpMLJKkqpOEqSpKqTCYpJKkqpMJJUlSVUlSVWF9D0fS9P1PV9b1/Y9n2vb1NXW1
9jZ2tvc3d7f4OHi4+Tl5ufo6err7O3u7/DxMfLz9PU5QjlDOkRFRgAAAAAAAjpCSlfFLTE1O
+SeoKKkpqiqrK6wsrS2uLq8vsDCxMbIyszO0NLU1tja3N7g4uTm6N7g4uTm6Ors7vDy9Pb4+
vz/AQMFBwkLDQ8RExUXGRsdHyEjJScpKy0vMTM1Nzk7PT9BR0lLTU9RU1VXWVtdX2FjZWNna
Wttb3FzdXd5e31/gYOFh4mLjY+Rk5WXmZudn6GjpafR/rpdPqdXrdfsdntdvud3vd/weHxeP
yeX+/N5/P6PT6v89fs9vu9/w+Py+f0+v+/8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAQsEEEJBBCQkEELBBBUlVJhKlVJKqqlVJJgwYMGDBgwYaSVJVSYfJKqpKr+1V
UqpKrBgwYXgwYMABglVUqpKq7u7u7AAC6qpVSVV3d3d2Aw+SSgCSSSQAkkkkAJJJJADBVVKq
Sq/pVVVVV3d3dpJJJACSSSQAkkkkAKoB11VUqpJLu7u71aSVJVSXd3d2AAAAAAAAAAPBklSV
Ul3d3dgAAAAAAAAAAAAAcpJKkqpLu7u7AAAAAAAAAAAAAAAAAAAAA86SVJVSXd3d2AAYJJUl
VJd3d3YAAAAAAAAAAAAAHhSSpKqS7u7uwHKySpKqS7u7uwAAAAAAAAAAAAAAADBJKkqpLu7u
7AAAAAAAAAAAAB80kqSqku7u7sAAAAAAAAAAAAAAAAAAAGNSSpKqS7u7uwADeJJUlVJd3d3Y
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

--------------2km7M7M3B0fs228B1htiZyCX--
