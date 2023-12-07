Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="c8upFslN"
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 140731710
	for <linux-xfs@vger.kernel.org>; Thu,  7 Dec 2023 15:17:46 -0800 (PST)
Received: by mail-oi1-x233.google.com with SMTP id 5614622812f47-3b8958b32a2so1035522b6e.2
        for <linux-xfs@vger.kernel.org>; Thu, 07 Dec 2023 15:17:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1701991065; x=1702595865; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=oc4bA9M1yvR4pT8YThY6bhURrgrhHBA9XdhaNkdspEE=;
        b=c8upFslNBx3BsJd09R1qE6dn3QoYvHDxZdvd+MTT9HkIqMO8JBjrrUbW+Tkin1/tuD
         nI9+DCTuRpa1kKKZg7bjpw7M89VCRRbBE6bq7bo4z3gDtuWf6GXrxqvv4kil3fnAQQuJ
         sFXEbwq0mPv6CQY1ZzZS5AGnNXtmESW8QeBluuezArK6VdDRAfuCAKoc0lLQfUIFiSg/
         Ms1vn2unr9CeYF+Y56rUwSqVWltvad5OQnk6iKFXxwMPO+NMSmIN/xPJhFi8ycH3N+mx
         7OK6XWF6yR8wCfjtiNlxPUH4iDG4XA3LbRn/UZOEhV19iim4fJSVLqkHqZdGOSLO+aZl
         5s5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701991065; x=1702595865;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oc4bA9M1yvR4pT8YThY6bhURrgrhHBA9XdhaNkdspEE=;
        b=f4S4MfLuSQiVKiYT8CaKaF23tf7YKRWLfIfUFJx/eMdcjZvRXDN+sCERTp8vFoRZNw
         Yze/QbBDZ4X8dkF86soDkPfv+MqzO5LoOT3//uK0whn8fbk2/Qp1GvIs2W1NnWDvLDAC
         PUbDt2mhpNQCTlqlwWg3jVnkD0kZjNWOVhy9VFu2y0PecTAa7HEY15IbSqX0vE7Zs4/k
         QxmuF8Uz1Gk0xnRiLOueF9pbkEUsof/+kSEAc35WQAAX9Q0sq2ydNf4FzvRMkoO1qxdZ
         TbHjsrv0GhAmBgkjQi45O+XfK28iR7fLW/VxprWjyy+i0Ua0FJ/RuFnGr1llOtEriyxM
         WyAQ==
X-Gm-Message-State: AOJu0YxbdxB9gI7bwRxo9/gR1tNk8HCBKwN3Vgm/3n2NuwJ1Esv22tZr
	0U67t4beYOBmF2VBX789asY3eRz9iL8sJvntoAU=
X-Google-Smtp-Source: AGHT+IH6N3XNhXbpWHfjKgkb/614qqqAfDqgt7qP9V6d7Bi9PcVrw7yhgFj24Kw6CSg9/Qo8XI4ITQ==
X-Received: by 2002:a05:6808:294:b0:3b9:de63:f514 with SMTP id z20-20020a056808029400b003b9de63f514mr1677624oic.12.1701991065399;
        Thu, 07 Dec 2023 15:17:45 -0800 (PST)
Received: from dread.disaster.area (pa49-180-125-5.pa.nsw.optusnet.com.au. [49.180.125.5])
        by smtp.gmail.com with ESMTPSA id p2-20020aa78602000000b006ce691a1419sm311993pfn.186.2023.12.07.15.17.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Dec 2023 15:17:44 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rBNcj-005H7L-0w;
	Fri, 08 Dec 2023 10:17:41 +1100
Date: Fri, 8 Dec 2023 10:17:41 +1100
From: Dave Chinner <david@fromorbit.com>
To: Srikanth C S <srikanth.c.s@oracle.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: Question: Is growing log size when filesystem is grown a
 feasible solution
Message-ID: <ZXJSlbgfg70d8Bqo@dread.disaster.area>
References: <CY8PR10MB72412C0E92BBB12726E3A6C0A38BA@CY8PR10MB7241.namprd10.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CY8PR10MB72412C0E92BBB12726E3A6C0A38BA@CY8PR10MB7241.namprd10.prod.outlook.com>

On Thu, Dec 07, 2023 at 09:17:09AM +0000, Srikanth C S wrote:
> Hi all,
> 
> We had earlier seen a few instances where there was an impact
> in the read/write performance with processes stuck in
> xlog_grant_head_wait(). And our investigation brought us to the
> conclusion that the limitation in log space was causing this.
> This was when we have a lot of read/write going through and the
> log space was limited.
> 
> The problem was seen especially when the file system was small
> initially and later grown to a larger size using xfs_growfs.
> The log size does not grow when the FS is grown. In these cases,
> we are stuck with the same log size calculated for the smaller
> file system size (which was 10MB, the earlier default value).
> 
> The problem was partially addressed by the commit:
> cdfa467 mkfs: increase the minimum log size to 64MB when possible
> 
> This commit make the default log size to 64MB for new filesystems,
> but does not address the issue for existing filesystems with a
> small log size. The only solution for such Fs is to recreate it
> from scratch, which is not feasible for production systems. Hence,
> there is a need to provide a solution - and we want to explore
> possibility of growing the log size using xfs_growfs.
> 
> It would be great if I can get some comments from the community
> if the change where xfs_growfs can grow the log is encouraged.
> If it is, then any advice or comments on how to proceed with the
> problem would be great too.

It's possible to implement an online log resize. That doesn't mean
it is easy to do. Start thinking about all the failure modes and how
to reliably avoid and/or recover from such failures.

e.g. how do you do an atomic swap from the old log to the new log in
a way that if we crash in the middle of the operation then log
recovery on the next mount will result in either the original state
on the old journal (nothing has changed) or that full operation
completion occurs (running on a fully initialised new journal).

Doing it offline is simpler, but there's still a bunch of metadata
modifications that have to be done correctly. i.e. we still have to
handle the case that the system could crash half way through the
offline log move operation in a manner that doesn't trash the
filesystem or user data.

If you've got 6 months to a year to spend getting all this right,
then I don't think anyone if going to say not to being able to
resize logs and/or convert internal/external logs dynamically. It's
just a lot of work to make it robust and reliable....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
