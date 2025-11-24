Received: from mail-ed1-f66.google.com (mail-ed1-f66.google.com [209.85.208.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA12A26F478
	for <linux-xfs@vger.kernel.org>; Mon, 24 Nov 2025 07:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763968040; cv=none; b=e9PFDO3uxfmC5YZu8Qy9mBTDZLVBBe6hE/n/QIvt1RXAQqeEfk04lOjspmCujibtijIeuyerOI3Rk9sQe++w1GUNLLYN2QkOSu7E8FLM8AdNPo8rvtgoYlPzZoQ3YmTSB9hTO7tH8S8AQv9jDJmFG9ehJmqKnFEzf3v61txpr4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763968040; c=relaxed/simple;
	bh=rEHj+bV/RPJbHXojWJRA8/3ttgzIS3FVoJAczbcGBx4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=m+a8CVPBoUyhAui1NxUHNZ59tAddq/y1h72wd8G/mEFT+YEWku3TUxrE1oo1jg0y7801Tn8LlYWS4vAvIvdcM2YoH0G2xOr7XaTkgvL9fZMxDk/HIWBQ7Ji6pkXRqCWVd41p0s+khRVfmkZPi8F+lsO672oSd5Uu/x5kiBkPCXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lcbXGJzG; arc=none smtp.client-ip=209.85.208.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lcbXGJzG"
Received: by mail-ed1-f66.google.com with SMTP id 4fb4d7f45d1cf-640b0639dabso6752386a12.3
        for <linux-xfs@vger.kernel.org>; Sun, 23 Nov 2025 23:07:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763968037; x=1764572837; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Yi/T3OLG8v3Ep8T6dgr2j2yJZQAdU1EwTu+WWFkTUkI=;
        b=lcbXGJzGFV+Bq7qRg5+kAeTmIcx1IKe+g66sqDDlneJZFbYuq4fR21h+kjFkWuDQS0
         A2XFlPjp35PF5Cey6SDzvxiTyMN7CnYQ3jIvrPW/PDj91lt3bAykbTBmR/K9seYW+RyR
         ROPG2uUQE8tY5pQ0+M9nsMSkbtDKi5qq0GSIbS7YJlCUnBtDS1VxBOx/Eq81ooKQ5f/x
         ItYVfHtLAk2u307VmPMvDnsYT2XuzETCinnS6kOQwySEg426lw8dcj+yS2dGyOJzzXjS
         7kfR4ujpQb80aRDsyhS0hEdWI56KE1kpiZkbGzti/j/39bLHAkrPKdPgT4eOxE3JvOQl
         nSsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763968037; x=1764572837;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Yi/T3OLG8v3Ep8T6dgr2j2yJZQAdU1EwTu+WWFkTUkI=;
        b=KHJ8gqbyskWkGZG/mIQU97rlrEcV6NiZGlrc9S+AZ0yCpRGqTl22ARLSTzdrfhjKBP
         s31yB0fxruvnwrJK4SeEL23rBTGNXADM0xgiFcjFKiC6LnBJXINSR2ttudNjt1Q5//xy
         57xB9uHOaeOWIyzZ9WabZ6SkJKDqmiJRnZFZAq6h2YiBPLQn6tUHHioWQx7InIyEwn7e
         sKKp95mDqeE8FIcN+a1U4Wn6JqIoAg+yVhuLV5Nl2lvGMkEOut9CzKnpXMBHp8kE37xI
         +eDlN1itGXjo/iBVdZ7kqvI6h/OW9Qx7mcSvNk4ZY531GvZXtuZNudRerOzWA3JKfnBM
         +yOQ==
X-Forwarded-Encrypted: i=1; AJvYcCXOxeIRWMg+xQgpBUiONnkvCIGHO9zlYHq2YobUobZygBQw5tzD2e1tdiqPcMq7tuydjZWGaB92Rss=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxtyz0JffX4AYAcUfzktbK3I11PhtehEPnBJfC+u00emVFy9d3g
	c4EgOBi83zL8UU9mRz3WyGHSW6rm27Obwetf1+TXIpf+dVpolsRqxpH2/nFPqKGBwX1DJjzG/O/
	h69UkZyF10BaupV8peXoRcXFh/18o41M=
X-Gm-Gg: ASbGncuz6iQE1gzts7ieYetxCpM2SPZ+8dZTG64BNXgARGLY878VGWZTQjMI84XYCEC
	oMdmigPE2Gj6AO6IGWphRE9Rt/iIEMgb3BHzspudkHcEj+y8EvvFpCujfY4J8Uc/wy1kbaW0TB1
	Rs6b8BXPQLWiRwyUE3IoPkzjQJd0HcIclXYTmJqw/RpC/mY50jMrMdcKJP7lzdI1g3pW2tpjzTK
	/1lLuwi9eT6mehn//dArfBhHaHMmhZGjOGZbRVd6w6DeRy1a27dGMwI9kYA1QJfw6aM0g==
X-Google-Smtp-Source: AGHT+IGwORyD+UDlNzjYRQdzGPio+VxMb3k0lqvFXqxJxqHDiIRmvAyaL+eJwmCoWO2QrmCTclCTWhxMmIWnLvaZz9U=
X-Received: by 2002:a05:6402:4314:b0:640:96fe:c7b8 with SMTP id
 4fb4d7f45d1cf-64554339994mr9059179a12.2.1763968036771; Sun, 23 Nov 2025
 23:07:16 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAEjiKSkcLrkpzxUadKCyGEzHV503Q_htisU=rANk_zHoj9U04g@mail.gmail.com>
 <20251124041344.1563186-1-alexjlzheng@tencent.com>
In-Reply-To: <20251124041344.1563186-1-alexjlzheng@tencent.com>
From: haoqin huang <haoqinhuang7@gmail.com>
Date: Mon, 24 Nov 2025 15:07:04 +0800
X-Gm-Features: AWmQ_bnnqW2TE-BKBE4Oqx6jW6r-dTZ_kIfzr14ss5g6VKhtUs1vTBthQwXFDzg
Message-ID: <CAEjiKSmGfHQ1i2RNa7UTbeVaABxppTnkNG9K-ErUvKda_KmUpw@mail.gmail.com>
Subject: Re: [PATCH] xfs: fix deadlock between busy flushing and t_busy
To: Jinliang Zheng <alexjlzheng@gmail.com>
Cc: chandan.babu@oracle.com, david@fromorbit.com, djwong@kernel.org, 
	haoqinhuang@tencent.com, linux-xfs@vger.kernel.org, zigiwang@tencent.com, 
	rongwei.wrw@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 24, 2025 at 12:13=E2=80=AFPM Jinliang Zheng <alexjlzheng@gmail.=
com> wrote:
>
> On Sat, 22 Nov 2025 17:41:49 +0800, haoqinhuang7@gmail.com wrote:
> > Hi Dave,
> >
> > Thanks for your reviews, and sorry for response lately.
> >
> > I=E2=80=99m very agree that deferred frees largely resolved the deadloc=
k issue.
> >
> > Maybe I should split two parts of this patch to show my idea:
> > Part 1. fix fallback of xfs_refcount_split_extent()
> > It seems better to  fix a logic bug in xfs_refcount_split_extent().
> > When splitting an extent, we update the existing record before
> > inserting the new one. If the insertion fails, we currently return
> > without restoring the original record, leaving the btree in an
> > inconsistent state.
>
> Is the error handling part in xfs_trans_commit() sufficient to handle
> the situation you described? (I haven't carefully verified it.)
>
> Jinliang Zheng. :)

Hi Jinliang,

Thanks for your suggestion, I couldn't find how xfs_trans_commit()
handles this issue. Maybe you can describe it in detail. What's more,
I see some assertions will be triggered if we don't restore this right
extent, likes:
xfs_refcount_split_extent() updates the existing right extent before
inserting the new one for the left extent. If insertion fails, the
right extent is left in an inconsistent state.

When xfs_defer_finish_noroll() attempts to retry the deferred
operation, because the tree was modified but not restored, the
cursor's path becomes invalid regarding the tree structure. This
triggers the ASSERT(0) in xfs_btree_increment():
if (lev =3D=3D cur->bc_nlevels) {
if (cur->bc_flags & XFS_BTREE_ROOT_IN_INODE)
goto out0;
ASSERT(0);
=E2=80=A6=E2=80=A6
}
IMO, it seems better to restore the original record in
xfs_refcount_split_extent() to ensure the btree remains consistent if
the insertion fails.
