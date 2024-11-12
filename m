Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E063218D7C
	for <linux-xfs@vger.kernel.org>; Tue, 12 Nov 2024 20:12:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731442362; cv=none; b=Y7Vx5Htp0OWMy7xUeKwiGBUJaLeRMuJZuYIiPkVaBxeiqtvuzoupFroL0XKKZItzHz60VQ79ZsbbCwSx2G8E+f0g0frKOtjuFGQpZjYZHbqhD3CGdjERuf6RPgbSZGGuj0uwAst8s2QYtPbiUAO2TtT946o2Foa0l8oz5YpABdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731442362; c=relaxed/simple;
	bh=APg3rcEySs1o4uLtYJBcvRsc9Qe6Q1ZTOQRJgr9MbAs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ly71cGRxuPDCsZx0BiVvmsUmuHwu4NcaR5hbG0ASXsFtKM+LJIcHLXCVLquQweojmIaZw4inRxq9hS/vAa3cfiP7PCW76PjBVwXDJ9MW865s2Ro3V9jLbPh3z6HltZh4gzSJu0UQs1BdWbt48hNZL5X0S0q3omn46tc9O3TenDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FcOcY1Xx; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FcOcY1Xx"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-a99fa009adcso409177666b.0
        for <linux-xfs@vger.kernel.org>; Tue, 12 Nov 2024 12:12:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1731442358; x=1732047158; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=0qYB3r0e+M+AIIS7skjeHUYQNaIJb6UwbAHof7SMGqw=;
        b=FcOcY1XxfT+AIEI3USMaJFNGOqARqrtF9owUJtu2wEb7/ptVNOsHJ84QKKDrH5zKzp
         90B3GLsaMtaZ4HVVL5aEiXKC15V6zMLNLhjI5TOcBsuOrvNzEgQIwbqIsahkizx7bcwv
         BNcShXFPkvJ4eS56JamG12HyOxMXJWxI5cuFg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731442358; x=1732047158;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0qYB3r0e+M+AIIS7skjeHUYQNaIJb6UwbAHof7SMGqw=;
        b=ildopAIwnfefoumxEzD6I7K4BvlPSf+gt22fRXB6zBTioC0QtetLbC1xp+Nmf4Oql8
         PF7IQmndhanYjaS/0Qy0iq6g/dgW4BOYNAV8taKeg+qyC3dZZ2GFYQ8XZRxGTZ+295GA
         +4RbiYtPVeaG8QGFoQdMI5/PZFiIxKjuMh9sgq3OgnFJDzxSMT/akmYaqSljxTHSg+Dl
         DvVQNi5XLFvhlpUk2lBhCxs/uXKCe/G1HFF/u60S/2dsYHPG/UuoXMaY7qJO6vrSlLOa
         aaNmZ4Jx3jfXdIhdo7p55XMk+Euls72RHawf/4LQ/w/ur341wcdTbjljRs3PEwET1CyF
         a0OQ==
X-Forwarded-Encrypted: i=1; AJvYcCUrq44JETVQggQy0+Z4BqJdHUxj0TdpbB6Vf607vWJ9mpvo7SjpMctHNhKLuiePjw4Faax3sex21kA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwwXtW6yB+k1upYQFB8FnBz9/l11QvBOzsMiRWs1R5lxoqPqXFw
	7mNTWsgPd75rKMS/uO+2vSgM8O+8+FgXPFx4Ek5bzd6VYBv0uWXF+267s0kGw/Is0/vvBssdjlu
	4tNZo9g==
X-Google-Smtp-Source: AGHT+IEagsQcLPu2ROL/vCE5eJ0ReYhe2naJYtooELLazkwHECU5QJ72Sw+s8KVNgDvSAII2nfMmSg==
X-Received: by 2002:a05:6402:4405:b0:5ce:d435:c26d with SMTP id 4fb4d7f45d1cf-5cf0a3206ecmr22090503a12.19.1731442358480;
        Tue, 12 Nov 2024 12:12:38 -0800 (PST)
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com. [209.85.208.42])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5cf03c7cabbsm6353280a12.79.2024.11.12.12.12.37
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Nov 2024 12:12:37 -0800 (PST)
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-5cf0810f5f9so3944694a12.0
        for <linux-xfs@vger.kernel.org>; Tue, 12 Nov 2024 12:12:37 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWGCnjz6uTcVh9X2V8UwmK2Cqte3p7M/uoHS/yjmwWZD2IBZyL6siG0U5GrdlBABUGCNcj9YcrHAzE=@vger.kernel.org
X-Received: by 2002:a50:cd1d:0:b0:5cf:22ab:c3b5 with SMTP id
 4fb4d7f45d1cf-5cf22abcab5mr13468088a12.1.1731442356992; Tue, 12 Nov 2024
 12:12:36 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1731433903.git.josef@toxicpanda.com> <141e2cc2dfac8b2f49c1c8d219dd7c20925b2cef.1731433903.git.josef@toxicpanda.com>
In-Reply-To: <141e2cc2dfac8b2f49c1c8d219dd7c20925b2cef.1731433903.git.josef@toxicpanda.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 12 Nov 2024 12:12:20 -0800
X-Gmail-Original-Message-ID: <CAHk-=wjkBEch_Z9EMbup2bHtbtt7aoj-o5V6Nara+VxeUtckGw@mail.gmail.com>
Message-ID: <CAHk-=wjkBEch_Z9EMbup2bHtbtt7aoj-o5V6Nara+VxeUtckGw@mail.gmail.com>
Subject: Re: [PATCH v7 05/18] fsnotify: introduce pre-content permission events
To: Josef Bacik <josef@toxicpanda.com>
Cc: kernel-team@fb.com, linux-fsdevel@vger.kernel.org, jack@suse.cz, 
	amir73il@gmail.com, brauner@kernel.org, linux-xfs@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, linux-mm@kvack.org, linux-ext4@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 12 Nov 2024 at 09:56, Josef Bacik <josef@toxicpanda.com> wrote:
>
>  #ifdef CONFIG_FANOTIFY_ACCESS_PERMISSIONS
> +static inline int fsnotify_pre_content(struct file *file)
> +{
> +       struct inode *inode = file_inode(file);
> +
> +       /*
> +        * Pre-content events are only reported for regular files and dirs
> +        * if there are any pre-content event watchers on this sb.
> +        */
> +       if ((!S_ISDIR(inode->i_mode) && !S_ISREG(inode->i_mode)) ||
> +           !(inode->i_sb->s_iflags & SB_I_ALLOW_HSM) ||
> +           !fsnotify_sb_has_priority_watchers(inode->i_sb,
> +                                              FSNOTIFY_PRIO_PRE_CONTENT))
> +               return 0;
> +
> +       return fsnotify_file(file, FS_PRE_ACCESS);
> +}

Yeah, no.

None of this should check inode->i_sb->s_iflags at any point.

The "is there a pre-content" thing should check one thing, and one
thing only: that "is this file watched" flag.

The whole indecipherable mess of inline functions that do random
things in <linux/fsnotify.h> needs to be cleaned up, not made even
more indecipherable.

I'm NAKing this whole series until this is all sane and cleaned up,
and I don't want to see a new hacky version being sent out tomorrow
with just another layer of new hacks, with random new inline functions
that call other inline functions and have complex odd conditionals
that make no sense.

Really. If the new hooks don't have that *SINGLE* bit test, they will
not get merged.

And that *SINGLE* bit test had better not be hidden under multiple
layers of odd inline functions.

You DO NOT get to use the same old broken complex function for the new
hooks that then mix these odd helpers.

This whole "add another crazy inline function using another crazy
helper needs to STOP. Later on in the patch series you do

+/*
+ * fsnotify_truncate_perm - permission hook before file truncate
+ */
+static inline int fsnotify_truncate_perm(const struct path *path,
loff_t length)
+{
+       return fsnotify_pre_content(path, &length, 0);
+}

or things like this:

+static inline bool fsnotify_file_has_pre_content_watches(struct file *file)
+{
+       if (!(file->f_mode & FMODE_NOTIFY_PERM))
+               return false;
+
+       if (!(file_inode(file)->i_sb->s_iflags & SB_I_ALLOW_HSM))
+               return false;
+
+       return fsnotify_file_object_watched(file, FSNOTIFY_PRE_CONTENT_EVENTS);
+}

and no, NONE of that should be tested at runtime.

I repeat: you should have *ONE* inline function that basically does

 static inline bool fsnotify_file_watched(struct file *file)
 {
        return file && unlikely(file->f_mode & FMODE_NOTIFY_PERM);
 }

and absolutely nothing else. If that file is set, the file has
notification events, and you go to an out-of-line slow case. You don't
inline the unlikely cases after that.

And you make sure that you only set that special bit on files and
filesystems that support it. You most definitely don't check for
SB_I_ALLOW_HSM kind of flags at runtime in critical code.

               Linus
