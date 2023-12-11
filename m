Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="YhX9FOww"
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D7521B8
	for <linux-xfs@vger.kernel.org>; Mon, 11 Dec 2023 14:00:55 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id 41be03b00d2f7-5be30d543c4so2870843a12.2
        for <linux-xfs@vger.kernel.org>; Mon, 11 Dec 2023 14:00:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1702332054; x=1702936854; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=YkJANNnHkDatMX3OvQ3wtH5uHZhNJpOmW1DPV1p/gRM=;
        b=YhX9FOwwni0zAtgbngkycFxh5QR43Y3qh9wWNJSpmg11Ml1a8oLawNCxi2jvOwt5SN
         fc78gsQblxlLrBGBbV85WCIIF4o1b9tnlFALrF4FcT7SXPBlLMhjcaDJ9/DsyajvgaOg
         QIJga59+LhKQbH3L2anrmjsnQiosUTgA+M3YwivLqm9aUa7+VjMjfFx2V8qPnaTtPRhU
         tYpsADcZviK2eDuQq+fQmSf7VzBgncHJXIjXWEJmo6AAQPUsxVVisHOJ83DhcYTJ56Hn
         B+h0bmlt3zLZrD6/GMrUiM9wRUY9SueWfNMqZp4vwQPsXuXjVR+T0fLTIZTntq+b65hs
         3UCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702332054; x=1702936854;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YkJANNnHkDatMX3OvQ3wtH5uHZhNJpOmW1DPV1p/gRM=;
        b=Xe7EalQ4W/DvY3BR9Ql08uXRhUjr5WqexnSibziMrywQj/Z7gtBZooPEGUlvj+eVx2
         stV4qXWDU9gE6P5CnxaPev87+ROW6MKVCga2FgGH5ys2DxlclMWGoAd075J4dTTEopBW
         dDzdMiI5ybQ2b9c/zj0a0u1Hyi0B92eYtXd8+rIdqYtUECdjm/HrED/KEQyP42WK+NmM
         BNTHamcLq2j/lYfU/dTbcVP9DwsGfWr7H7u7DM1YuPctFHumHbTgHiZu3k6VPmKkn4xI
         NXsUYGkefn1UgPGqlDi6+w5//6g2XqnjP1y1rtJsJxXkBfJeagwox+M19Kz7m+zPcY9S
         HmsQ==
X-Gm-Message-State: AOJu0YwatGTKV0ZbIGcym40YLMJpF+IRSMo0crFJk4YQRslhHgUaAQqR
	Soy+VBNs1E40y1jWByG66Yg+1Q==
X-Google-Smtp-Source: AGHT+IEgP6QixM37BcvnibWDgGWb4fQbih1iqigMzwzvcH3IyK1/S1/LDn4F2sLXeX+eIIavuFv7Yg==
X-Received: by 2002:a05:6a20:1586:b0:18f:97c:823d with SMTP id h6-20020a056a20158600b0018f097c823dmr3027850pzj.71.1702332054443;
        Mon, 11 Dec 2023 14:00:54 -0800 (PST)
Received: from dread.disaster.area (pa49-180-125-5.pa.nsw.optusnet.com.au. [49.180.125.5])
        by smtp.gmail.com with ESMTPSA id ei43-20020a056a0080eb00b006ce6e431292sm6758708pfb.38.2023.12.11.14.00.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Dec 2023 14:00:53 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rCoKY-0071vN-12;
	Tue, 12 Dec 2023 09:00:50 +1100
Date: Tue, 12 Dec 2023 09:00:50 +1100
From: Dave Chinner <david@fromorbit.com>
To: Long Li <leo.lilong@huawei.com>
Cc: djwong@kernel.org, chandanbabu@kernel.org, linux-xfs@vger.kernel.org,
	yi.zhang@huawei.com, houtao1@huawei.com, yangerkun@huawei.com
Subject: Re: [PATCH v2 2/3] xfs: don't assert perag when free perag
Message-ID: <ZXeGkisobA2nXX5D@dread.disaster.area>
References: <20231209122107.2422441-1-leo.lilong@huawei.com>
 <20231209122107.2422441-2-leo.lilong@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231209122107.2422441-2-leo.lilong@huawei.com>

On Sat, Dec 09, 2023 at 08:21:06PM +0800, Long Li wrote:
> When releasing the perag in xfs_free_perag(), the assertion that the
> perag in readix tree is correct in most cases. However, there is one
> corner case where the assertion is not true. During log recovery, the
> AGs become visible(that is included in mp->m_sb.sb_agcount) first, and
> then the perag is initialized. If the initialization of the perag fails,
> the assertion will be triggered. Worse yet, null pointer dereferencing
> can occur.

I'm going to assume that you are talking about xlog_do_recover()
because the commit message doesn't actually tell us how this
situation occurs.

That code re-reads the superblock, then copies it to mp->m_sb,
then calls xfs_initialize_perag() with the values from mp->m_sb.

If log recovery replayed a growfs transaction, the mp->m_sb has a
larger sb_agcount and so then xfs_initialize_perag() is called
and if that fails we end up back in xfs_mountfs and the error
stack calls xfs_free_perag().

Is that correct?

If so, then the fix is to change how xlog_do_recover() works. It
needs to initialise the new perags before it updates the in-memory
superblock. If xfs_initialize_perag() fails, it undoes all the
changes it has made, so if we haven't updated the in-memory
superblock when the init of the new perags fails then the error
unwinding code works exactly as it should right now.

i.e. the bug is that xlog_do_recover() is leaving the in-memory
state inconsistent on init failure, and we need to fix that rather
than remove the assert that is telling us that in-memory state is
inconsistent....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
