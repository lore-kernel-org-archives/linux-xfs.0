Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D5163214;
	Mon,  4 Nov 2024 01:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730685011; cv=none; b=RjChc1198nAx+c60IU59xnuYg5Cs60Tt0br0Gp2uf0cU4npZign/VLoeBiK8cDQqq+vlJ41Ix9SmlC9ZWFaGFbNK/Ol5a3YrF5vFCbM2T/LEafeVxOSmdbbXn/urz/u/KFYoBaTMQ3e1Lf8S+TkrLCH3PKPlMGk4N5ryQtIxkME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730685011; c=relaxed/simple;
	bh=rSZg9dkgH3TInoIPgDQV+QRUjhKNkNHlMHg6SywoLlo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZbHqweTse3IuRWI5w/W4fn2ZACxHGVoslV4l1LQ7BLP/qcPDr2QH15SUdPXHxK+O0gYIBrFRoBxb8/kiLAHdTNLSh3v3Cq+Yd0LEsvRBytMvy9YSs2QCnlgw0f/8tzUphU4rElwf4njwl3LdESY7nVUPo70/DNNwAm8i48ZZQU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=X5hjPvEr; arc=none smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="X5hjPvEr"
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-462d8b29c14so2259181cf.1;
        Sun, 03 Nov 2024 17:50:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730685009; x=1731289809; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=sQLKsivBO2u0kBUtRSOY/FkwvE9/gfQy9B+xNfqoJNo=;
        b=X5hjPvEraaEzDMFqrnDK4AK8jEngMwrThCGzC1CqIBBd9LdeYUkStHghUty8w/IJxR
         LYmc/RpchC96BbTXbfff0eHftsl3UtTrnPC8eGv/TXwMTETfH4c2n4h+lssvjGR6nCDk
         xR1I98rR0D3pcJhbhOfM6ZlZm6qgbux7j3ZJ21YEz9S+DnWbLfMaWOlkiNXoEO1IpGgn
         z2zjRFVQgS4JM9qpHRc3+xXXYqgB5KyIUp3XrdtSWGpacvcB6sEiLf9XyvKJ5I1lXD+E
         NKmABBKesFoAfZbPE0XxZ9dNWqyZvOGVGsww9xTcD1MJbc9S5uRFaDlY9U34wfURYTtN
         Meqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730685009; x=1731289809;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sQLKsivBO2u0kBUtRSOY/FkwvE9/gfQy9B+xNfqoJNo=;
        b=ksalrppfVdQRnWUZb/WjiSKBPkEaGVjXWHtUfQHn+D2f7s4frw9N6JXdvi5K8nU+r8
         it52vfhR/NFv9S9kbMVDAP8Ir8xYP9dzOeKU1Eq6n9LWCy8BIIlWVFLpipyNoZJLE+OM
         43qmSHk7NYcit21fIQ2SEOjWKxWogWHvJsEmGbj/vkqIO92clPkvzX2YitQ8tn3CgNcF
         Idts28BMmnkmzd43KZMOyU1UC6AOvoDIXcusAJSaqD4u2htm4KSHE9zzM3WBmfBT4js1
         X0LtnT0bai1Y5tYUzqqcsF8oiK+RFIrlLWYFBhhihGORHp+Kxdyi1N8H9uX8f+IS4ZFT
         2Lbw==
X-Forwarded-Encrypted: i=1; AJvYcCXqTO+QJa5kTx0t1aSy9DH1/ox42j871yjRxVK9uGKWMBhqNcOJFQSxu5C9ZlOcmlE0mqnCxkOJV3DhEe4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy6lkbj93QjQvrlj3CfmANd/WKGBLPjKsCfRET+xRo3m7fpF/8M
	tFqUyI4amBLDY1bZmuuRHTvYiE/aaDwE4syGsADDmDMsDZtzx3q4pLi2phSqoyTQDGMg6titk4j
	YlSpEdAe4Bdzz2y5NTCMvLJ/WzKA=
X-Google-Smtp-Source: AGHT+IEfjubMmQCVgs6Lp5rqq2lQko5F6bNJW74s5oTdrFsfFqF6mYaEC+9xMDGv+C1aCuHaAToKrJPvhK19Z6FmbpI=
X-Received: by 2002:a05:622a:15d6:b0:462:67f0:596e with SMTP id
 d75a77b69052e-46267f05d63mr235248791cf.1.1730685009005; Sun, 03 Nov 2024
 17:50:09 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241104014439.3786609-1-zhangshida@kylinos.cn>
In-Reply-To: <20241104014439.3786609-1-zhangshida@kylinos.cn>
From: Stephen Zhang <starzhangzsd@gmail.com>
Date: Mon, 4 Nov 2024 09:49:32 +0800
Message-ID: <CANubcdWwg3OB_YV4CteC7ZZBaQXOuvFG1oS7uN+TpabS=Z=Z2Q@mail.gmail.com>
Subject: Re: [PATCH 0/5] *** Introduce new space allocation algorithm ***
To: djwong@kernel.org, dchinner@redhat.com, leo.lilong@huawei.com, 
	wozizhi@huawei.com, osandov@fb.com, xiang@kernel.org, 
	zhangjiachen.jaycee@bytedance.com
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	zhangshida@kylinos.cn
Content-Type: multipart/mixed; boundary="0000000000002e608206260c8135"

--0000000000002e608206260c8135
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi all,

I just send the scripts to test these series here.

Cheers,
Shida

zhangshida <starzhangzsd@gmail.com> =E4=BA=8E2024=E5=B9=B411=E6=9C=884=E6=
=97=A5=E5=91=A8=E4=B8=80 09:44=E5=86=99=E9=81=93=EF=BC=9A
>
> From: Shida Zhang <zhangshida@kylinos.cn>
>
> Hi all,
>
> Recently, we've been encounter xfs problems from our two
> major users continuously.
> They are all manifested as the same phonomenon: a xfs
> filesystem can't touch new file when there are nearly
> half of the available space even with sparse inode enabled.
>
> It turns out that the filesystem is too fragmented to have
> enough continuous free space to create a new file.
>
> Life still has to goes on.
> But from our users' perspective, worse than the situation
> that xfs is hard to use is that xfs is non-able to use,
> since even one single file can't be created now.
>
> So we try to introduce a new space allocation algorithm to
> solve this.
>
> To achieve that, we try to propose a new concept:
>    Allocation Fields, where its name is borrowed from the
> mathmatical concepts(Groups,Rings,Fields), will be
> abbrivated as AF in the rest of the article.
>
> what is a AF?
> An one-pic-to-say-it-all version of explaination:
>
> |<--------+ af 0 +-------->|<--+ af 1 +-->| af 2|
> |------------------------------------------------+
> | ag 0 | ag 1 | ag 2 | ag 3| ag 4 | ag 5 | ag 6 |
> +------------------------------------------------+
>
> A text-based definition of AF:
> 1.An AF is a incore-only concept comparing with the on-disk
>   AG concept.
> 2.An AF is consisted of a continuous series of AGs.
> 3.Lower AFs will NEVER go to higher AFs for allocation if
>   it can complete it in the current AF.
>
> Rule 3 can serve as a barrier between the AF to slow down
> the over-speed extending of fragmented pieces.
>
> With these patches applied, the code logic will be exactly
> the same as the original code logic, unless you run with the
> extra mount opiton. For example:
>    mount -o af1=3D1 $dev $mnt
>
> That will change the default AF layout:
>
> |<--------+ af 0 +--------->|
> |----------------------------
> | ag 0 | ag 1 | ag 2 | ag 3 |
> +----------------------------
>
> to :
>
> |<-----+ af 0 +----->|<af 1>|
> |----------------------------
> | ag 0 | ag 1 | ag 2 | ag 3 |
> +----------------------------
>
> So the 'af1=3D1' here means the start agno is one ag away from
> the m_sb.agcount.
>
> We did some tests verify it. You can verify it yourself
> by running the following the command:
>
> 1. Create an 1g sized img file and formated it as xfs:
>   dd if=3D/dev/zero of=3Dtest.img bs=3D1M count=3D1024
>   mkfs.xfs -f test.img
>   sync
> 2. Make a mount directory:
>   mkdir mnt
> 3. Run the auto_frag.sh script, which will call another scripts
>   frag.sh. These scripts will be attached in the mail.
>   To enable the AF, run:
>     ./auto_frag.sh 1
>   To disable the AF, run:
>     ./auto_frag.sh 0
>
> Please feel free to communicate with us if you have any thoughts
> about these problems.
>
> Cheers,
> Shida
>
>
> Shida Zhang (5):
>   xfs: add two wrappers for iterating ags in a AF
>   xfs: add two mp member to record the alloction field layout
>   xfs: add mount options as a way to change the AF layout
>   xfs: add infrastructure to support AF allocation algorithm
>   xfs: modify the logic to comply with AF rules
>
>  fs/xfs/libxfs/xfs_ag.h         | 17 ++++++++++++
>  fs/xfs/libxfs/xfs_alloc.c      | 20 ++++++++++++++-
>  fs/xfs/libxfs/xfs_alloc.h      |  2 ++
>  fs/xfs/libxfs/xfs_bmap.c       | 47 ++++++++++++++++++++++++++++++++--
>  fs/xfs/libxfs/xfs_bmap_btree.c |  2 ++
>  fs/xfs/xfs_mount.h             |  3 +++
>  fs/xfs/xfs_super.c             | 12 ++++++++-
>  7 files changed, 99 insertions(+), 4 deletions(-)
>
> --
> 2.33.0
>

--0000000000002e608206260c8135
Content-Type: application/x-shellscript; name="auto_frag.sh"
Content-Disposition: attachment; filename="auto_frag.sh"
Content-Transfer-Encoding: base64
Content-ID: <f_m32d4b240>
X-Attachment-Id: f_m32d4b240

IyEvYmluL2Jhc2gKCmNsZWFudXAoKSB7CgllY2hvICJDdHJsK0MgZGV0ZWN0ZWQuIEtpbGxpbmcg
Y2hpbGQgcHJvY2Vzc2VzLi4uIiA+JjIKCXBraWxsIC1QICQkICMgS2lsbCBhbGwgY2hpbGQgcHJv
Y2Vzc2VzCglleGl0IDEKfQp0cmFwIGNsZWFudXAgU0lHSU5UIFNJR1RFUk0KCi4vZnJhZy5zaCB0
ZXN0LmltZyBtbnQvICAkKCg1MDAqMTAyNCkpIGZyYWcJJDEKLi9mcmFnLnNoIHRlc3QuaW1nIG1u
dC8gICQoKDIwMCoxMDI0KSkgZnJhZzIJJDEKLi9mcmFnLnNoIHRlc3QuaW1nIG1udC8gICQoKDEw
MCoxMDI0KSkgZnJhZzMJJDEKLi9mcmFnLnNoIHRlc3QuaW1nIG1udC8gICQoKDEwMCoxMDI0KSkg
ZnJhZzQJJDEKLi9mcmFnLnNoIHRlc3QuaW1nIG1udC8gICQoKDEwMCoxMDI0KSkgZnJhZzUJJDEK
Li9mcmFnLnNoIHRlc3QuaW1nIG1udC8gICQoKDEwMCoxMDI0KSkgZnJhZzYJJDEKLi9mcmFnLnNo
IHRlc3QuaW1nIG1udC8gICQoKDEwMCoxMDI0KSkgZnJhZzcJJDEKLi9mcmFnLnNoIHRlc3QuaW1n
IG1udC8gICQoKDEwMCoxMDI0KSkgZnJhZzgJJDEKLi9mcmFnLnNoIHRlc3QuaW1nIG1udC8gICQo
KDEwMCoxMDI0KSkgZnJhZzkJJDEKIAo=
--0000000000002e608206260c8135
Content-Type: application/x-shellscript; name="frag.sh"
Content-Disposition: attachment; filename="frag.sh"
Content-Transfer-Encoding: base64
Content-ID: <f_m32d4ibw1>
X-Attachment-Id: f_m32d4ibw1

I3VzYWdlOiAuL2ZyYWcuc2ggJGRldiAkZGlyICRzaXplX2sgJGZpbGVuYW1lIAojIS9iaW4vYmFz
aAoKY2xlYW51cCgpIHsKCWVjaG8gIkN0cmwrQyBkZXRlY3RlZC4gS2lsbGluZyBjaGlsZCBwcm9j
ZXNzZXMuLi4iID4mMgoJcGtpbGwgLVAgJCQgIyBLaWxsIGFsbCBjaGlsZCBwcm9jZXNzZXMKCWVj
aG8gImV4aXQuLi51bW91bnQgJHt0ZXN0X2Rldn0iID4mMgoJdW1vdW50ICR7dGVzdF9kZXZ9Cgll
eGl0IDEKfQp0cmFwIGNsZWFudXAgU0lHSU5UIFNJR1RFUk0KCnRlc3RfZGV2PSQxCmlmIFsgLXog
JHRlc3RfZGV2IF07IHRoZW4KCWVjaG8gInRlc3RfZGV2IGNhbnQgYmUgbnVsbCIKCWVjaG8gInVz
YWdlOiAuL2NyZWF0ZV9maWxlLnNoIFt0ZXN0X2Rldl0gW3Rlc3RfZGlyXSBbZmlsZV9zaXplX2td
IgoJZXhpdCAxCmZpCnRlc3RfbW50PSQyCmlmIFsgLXogJHRlc3RfbW50IF07IHRoZW4KCWVjaG8g
InRlc3RfbW50IGNhbnQgYmUgbnVsbCIKCWVjaG8gInVzYWdlOiAuL2NyZWF0ZV9maWxlLnNoIFt0
ZXN0X2Rldl0gW3Rlc3RfZGlyXSBbZmlsZV9zaXplX2tdIgoJZXhpdCAxCmZpCmZpbGVfc2l6ZV9r
PSQzCmlmIFsgLXogJHtmaWxlX3NpemVfa30gXTsgdGhlbgoJZWNobyAiZmlsZV9zaXplX2sgY2Fu
dCBiZSBudWxsIgoJZWNobyAidXNhZ2U6IC4vY3JlYXRlX2ZpbGUuc2ggW3Rlc3RfZGV2XSBbdGVz
dF9kaXJdIFtmaWxlX3NpemVfa10iCglleGl0IDEKZmkKZWNobyAidGVzdF9kZXY6JHt0ZXN0X2Rl
dn0gdGVzdF9tbnQ6JHt0ZXN0X21udH0gZml6ZV9zaXplOiR7ZmlsZV9zaXplX2t9S0IiCgojbWtm
cy54ZnMgLWYgJHt0ZXN0X2Rldn0KCmlmIFsgJDUgLWVxIDAgXTsgdGhlbgoJZWNobyAibW91bnQg
JHt0ZXN0X2Rldn0gJHt0ZXN0X21udH0iCgltb3VudCAkdGVzdF9kZXYgJHRlc3RfbW50CmVsc2UK
CWVjaG8gIm1vdW50IC1vIGFmMT0xICR7dGVzdF9kZXZ9ICR7dGVzdF9tbnR9IgoJbW91bnQgLW8g
YWYxPTEgJHRlc3RfZGV2ICR0ZXN0X21udApmaQoKCgojIFBhcmFtZXRlcnMKCkZJTEU9JHt0ZXN0
X21udH0vIiQ0IiAgICMgRmlsZSBuYW1lCmVjaG8gIiRGSUxFIgppZiBbIC16ICR7RklMRX0gXTsg
dGhlbgoJRklMRT0ke3Rlc3RfbW50fS8iZnJhZ21lbnRlZF9maWxlIiAgICMgRmlsZSBuYW1lCmZp
ClRPVEFMX1NJWkU9JHtmaWxlX3NpemVfa30JIyBUb3RhbCBzaXplIGluIEtCCkNIVU5LX1NJWkU9
NCAgICAgICAgICAgICAjIFNpemUgb2YgZWFjaCBwdW5jaCBvcGVyYXRpb24gaW4gS0IKCgojIENy
ZWF0ZSBhIGJpZyBmaWxlIHdpdGggYWxsb2NhdGVkIHNwYWNlCnhmc19pbyAtZiAtYyAiZmFsbG9j
IDAgJCgoVE9UQUxfU0laRSkpayIgJEZJTEUKCiMgQ2FsY3VsYXRlIHRvdGFsIG51bWJlciBvZiBw
dW5jaGVzIG5lZWRlZApOVU1fUFVOQ0hFUz0kKCggVE9UQUxfU0laRSAvIChDSFVOS19TSVpFICog
MikgKSkKCmxhc3RfcGVyY2VudGFnZT0tMQojIFB1bmNoIGhvbGVzIGFsdGVybmF0ZWx5IHRvIGNy
ZWF0ZSBmcmFnbWVudGF0aW9uCmZvciAoKGk9MDsgaTxOVU1fUFVOQ0hFUzsgaSsrKSk7IGRvCiAg
ICBPRkZTRVQ9JCgoIGkgKiBDSFVOS19TSVpFICogMiAqIDEwMjQgKSkKICAgIHhmc19pbyAtYyAi
ZnB1bmNoICRPRkZTRVQgJHtDSFVOS19TSVpFfWsiICRGSUxFCiAgICAKICAgICMgQ2FsY3VsYXRl
IGN1cnJlbnQgcGVyY2VudGFnZSBhbmQgcHJpbnQgaWYgY2hhbmdlZAogICAgUEVSQ0VOVEFHRT0k
KCggKGkgKyAxKSAqIDEwMCAvIE5VTV9QVU5DSEVTICkpCiAgICBpZiBbICIkUEVSQ0VOVEFHRSIg
LW5lICIkbGFzdF9wZXJjZW50YWdlIiBdOyB0aGVuCiAgICAgICAgI2VjaG8gIlByb2Nlc3Npbmcu
Li4ke1BFUkNFTlRBR0V9JSIKICAgICAgICBsYXN0X3BlcmNlbnRhZ2U9JFBFUkNFTlRBR0UKICAg
IGZpCmRvbmUKCiMgVmVyaWZ5IHRoZSBleHRlbnQgbGlzdCAodG8gc2VlIGZyYWdtZW50YXRpb24p
CiMgZWNobyAiRXh0ZW50IGxpc3QgZm9yIHRoZSBmaWxlOiIKIyB4ZnNfYm1hcCAtdiAkRklMRQpk
ZiAtVGggJHt0ZXN0X21udH0KCmVjaG8gInVtb3VudCAke3Rlc3RfZGV2fSIKdW1vdW50ICR0ZXN0
X2RldgoKeGZzX2RiIC1jICdmcmVlc3AnICR0ZXN0X2Rldgo=
--0000000000002e608206260c8135--
