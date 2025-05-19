Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BED644B1E76
	for <linux-xfs@vger.kernel.org>; Mon, 19 May 2025 00:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747615933; cv=none; b=XAbOsh0/bCaYqNuPyY0uZ/5tBqKhy0ZpbgWZHGzQdee0OEqR8fOXAwR0qMgSghWiCaJ+u0tLXcZfdm9H3vVbvtsZGU9pEGq+/75+6HT39+Lwd6U/JMmQNc9LT29LERD8J4cvvtHxyyasYvfbJOwkGLSiJlwuSUGZ5iVyD4a3C7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747615933; c=relaxed/simple;
	bh=UI+N4r7ZDJE3S1pabCwjGwU79TyYBWgr6EGeBl1zSyk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ciFh50197m9rMk2Vcl0hHcuZ7AeviQKHuzSXsL72DgpYNwuuh2iN9AhLJY2n0gMijyA4ATB/4TYFzr/7fFvqXf3v945wNZpdng4V6HGfQCBHpU1Ka9st7ZRD0nXvJXfsSitD2HffK6YKC4Ru9jQNtJh5ClLioIgxPfrfVApwHns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=WsY7qDWf; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="WsY7qDWf"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-7425bd5a83aso3894878b3a.0
        for <linux-xfs@vger.kernel.org>; Sun, 18 May 2025 17:52:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1747615931; x=1748220731; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+9RJYM4SfWiaD4Vs5enJgBL8+tKqb1yn3FbdhPUtIIw=;
        b=WsY7qDWfV4ZSdc1Kh2CB8wGiA1xburgC/RHILFpHZJqU391FUvm8QpdL/H4rYg/Rmd
         9vkdaZse33wAUsvKNLwIQox8pXXLbrD7583JeSX8JHwUHa1Nd7HRENlrrI4Ay/lVEenZ
         e0aGezfjsP+X3sXP8LJlDEpRDpM6rXb3kLsAVvm2QD0dAjnvC4Vn03iJNJpbW3kY72Hj
         6744uNgXYG3WJIJWZK4vXEFSg4oWlv1SX5NPodd7qkgRteXb49OcxgwuHt9hvgZP8XaB
         NKTWu7V0cGrP4NjKhS8onPGCNOoB3piHCSqQTdQXQVvx8OYrIF9qBzwcZrzfvaujlwD4
         v7CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747615931; x=1748220731;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+9RJYM4SfWiaD4Vs5enJgBL8+tKqb1yn3FbdhPUtIIw=;
        b=YWaNPwoUaFqR01p++uvgA7GwFs7632xphbEG0kc6d7Jok46ye1/WEZLe0R+PqELyr9
         8/RPa3faoiqwD5a/+p3iAdw8xgHc14IxzaKbg4fQatAoS4VWTYiYlFKTEm2adGsOyg1j
         YK2raRroVRrWlbbbJFd1IJ+4bKQHba3YsvGnwyP+Iq1exuDJ9tWtYc0pZ09wTa4MuOm+
         vrWQXOhfE9jnG8IYniV1NEPdT0GlmIHB8NpC87D3+fM7LzC42r6G2Im6wrU8LWEiSu8j
         Rtp5EmPQ1ZRvOGNaFFCfR/yfcu7d1NdYNtvRvAxBTLbIK+6UPzHelRlGU9aQK1qb09XV
         +WgA==
X-Gm-Message-State: AOJu0Yy2lHQDGXURoX5GDXh6ePSW4KYQ9L/rSQ3wMIybpblnDhJR7G11
	+8nfBEQPF0lsz2FmMw4YQTCTwZyt+/r5sVQYKIL5jjqIU7jR/6nSn5CZlnMnzaGS/IWrTq2K4gW
	q6+Wt
X-Gm-Gg: ASbGncvLNfuMmVl06NJN1NC5kFF848nPnEeMaaqpoL+F60r3imTTZzHniOPzbA6fyIo
	4wQU0pvs/VOcvNVx+zVykDVOx8/B/oqH76r9c/gzhSp6mQCNURXTy+OSlUAlN9O5/WO1S3+IPzf
	FqQsd/OJI7ysDvG8ND20TbO/YtXgmn0jQi9OptVtDUe19qUt1EWXAOeSItCzDKEQ2BUtCZ/E/hC
	jAPWlNIstAhrUHX5hJNfFDtT6wb658JQBH9Cmh0IL+0Vgj7S94LjTgOmlk22m9ydRpXc9HCeqEJ
	K1IsZCp3VJDxFiRhMRp60X/D63hFG1KPfmei3BsXzXb70splBenU6cD/ADjqWMzn/Lrm3iDUQRo
	bBxUsVPPYhVn+A5IzK3EX1E9kTCQ=
X-Google-Smtp-Source: AGHT+IHxj67A6bUaY5aFnmyf7R6EPuCzcFQDcCJIqoPl3n2mdn+5D+O9T8JRSKkTCC7Dla9EYlPQ/w==
X-Received: by 2002:a05:6a00:1148:b0:740:b372:be5 with SMTP id d2e1a72fcca58-742a97ac5b4mr12783270b3a.9.1747615930889;
        Sun, 18 May 2025 17:52:10 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-184-88.pa.nsw.optusnet.com.au. [49.180.184.88])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-742a970d64fsm5196474b3a.64.2025.05.18.17.52.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 May 2025 17:52:10 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1uGojf-00000005H7R-093g;
	Mon, 19 May 2025 10:52:07 +1000
Date: Mon, 19 May 2025 10:52:07 +1000
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: xfs <linux-xfs@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>,
	Jan Kara <jack@suse.cz>
Subject: Re: xfs office hours meeting minutes
Message-ID: <aCqAt3icmqt67ws5@dread.disaster.area>
References: <20250516233902.GA9705@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250516233902.GA9705@frogsfrogsfrogs>

On Fri, May 16, 2025 at 04:39:02PM -0700, Darrick J. Wong wrote:
> Hi everyone,
> 
> For background, Dave asked this on IRC on Tuesday:
> 
> [15:03] <dchinner> djwong: can you publish updated minutes for what is
> discussed during the office hours meeting?
> 
> After a couple of days of doing some research and thinking about this,
> I've decided that the answer is no, I cannot simultaneously facilitate
> the meeting /and/ produce a detailed minute-by-minute record of what was
> discussed.

I didn't ask for a transcript of the meeting, nor a detailed
recording of everything that everyone says.

> I welcome someone volunteering to function as a scribe,
> though I'll note that for most of the other community meetings (e.g.
> LSFMM, LPC, etc) minutes are not produced.

However, stuff like LSFMM (and often LPC) has detailed summaries of
each discussion published on the public record by community focussed
organisations like LWN....

> Like the ext4 community call, the weekly hour is spent on asking fairly
> mundane procedure questions of the release managers, people asking
> questions when they get stuck, a roundtable of what everyone's working
> on, and discussion of ideas.  This last thing is what I gather is the
> sticking point -- people are allergic to backroom settlement of
> conflicts that everyone is then bound to live with.

You're making a big assumption about why I asked this question,
Darrick.

I asked because the time at which the meeting is held is prohibitive
for me to attend, so unless there is some published record, I have
no idea what is happening in the wider XFS community.

Like yourself, I also want to know what everyone is working on, what
knowledge gaps they need filled, where they are getting stuck, what
are the most important problems that need to be solved, etc.

I had assumed, as the person running the meeting, that you would be
keeping notes of these sorts of things for followup purposes. At
minimum, private notes to remind yourself before the next meeting of
what people were struggling with last week. That's really all I was
asking to be published - I certainly don't want or need detailed
everything-he-said-and-she-said recordings of the meetings.

Perhaps that was a bad assumption to make that someone was taking
useful notes, but it never even crossed my mind that you weren't
taking any notes at all during the meeting.

> For those situations, I prefer to roughly follow the practice of ext4
> community call.  To my observation, that practice is that if we think
> we've settled a question, then a summary of that discussion will be sent
> to the list for broader examination.

Even if the issue is not settled, a summary of the discussion should
be published so everyone knows (or can discover) what has already
been discussed instead of treading the same ground on the mailing
list later on....

> That to me feels like a reasonable
> compromise between the unstructured conversations that occur on the call
> vs. maintaining a public record.

Except for the fact it doesn't provide any of the information I'd
like about what was discussed during the meetings.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
