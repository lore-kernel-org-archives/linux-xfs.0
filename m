Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B11342E175F
	for <linux-xfs@vger.kernel.org>; Tue,  2 Sep 2025 05:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756791066; cv=none; b=stuz5N3gN4aTGOpigwYPbznIRXh6KVS3hpWagZCyn8Zxmuk4eYZv5PaMRV1gxqDZaaDBBBhp6+rGUH3JLb8JcrBSe0SBVQJa8PncOBJdliA6ho/xhnC7oH1bfVzBV8qXSJa15GQDnPzvwgD4MkTRdECItTSN79eCDkOnP9GKurc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756791066; c=relaxed/simple;
	bh=LzO11EMMwQb66jd6pWaJNMo5WnFEAHb7gln3gpCspIw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Fnz6dT75oKIqOLjdcUDs4duoY/xV5Nzl9CUydU4C22aCe1koCWIbeLHoLa+8InU/IyR9jDA5wMTULeQHJ6TeirRyl/6uP83BH7vGKTx1NIFgTgqBm0zA9rQ2VKZHks15QHiIAnFX1bGdYXkEGirZgpjOADp/Q4D6ETeV+Bu9gFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UyRoM8Ba; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UyRoM8Ba"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756791061;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WZ9rGfd8aq/mP3BnSvKQ7EdybM5yoME4BtjzOi/mPuA=;
	b=UyRoM8Ba2jqWzvVCRbypNBtN4sknnICxNfZeoBsru5ytD9t/T4hyfxsybqGw0ZCcOXneYX
	9F4BrBB2rV/GSN/TP7jV1QaB9xmWHHm9aNsvpQCjbDuw1iRS5kp0CYrkZqItj+Rswstfdt
	dYu9CyS2MHdKO4W2TW/OLdBE9a6uTyA=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-284-uE131VdHOjWN09BxbOzOrw-1; Tue, 02 Sep 2025 01:30:59 -0400
X-MC-Unique: uE131VdHOjWN09BxbOzOrw-1
X-Mimecast-MFC-AGG-ID: uE131VdHOjWN09BxbOzOrw_1756791059
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-24aa3cf81a8so28100045ad.2
        for <linux-xfs@vger.kernel.org>; Mon, 01 Sep 2025 22:30:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756791059; x=1757395859;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WZ9rGfd8aq/mP3BnSvKQ7EdybM5yoME4BtjzOi/mPuA=;
        b=OSfCs6bOzmEo0zOGyG+vdpdPAUqA3jkGmu/sSSEymAnTGUEYaMP804HG+Ok+WTdR1h
         4AMPyFdB7V1YdpvoWa3a+Fp35yk25vDwqAV6JzT7swR5TGz7vWqyivt7yTyPghnfDRd5
         CriHOi4BFWT8WV7MjRGTTRgWEaq26cIz35EtE/m+c/43l4X/cTpbQXOj2NBvDa9Q6O5o
         5k7z3WVVsoqvTVYJICzSb6swNBEfSZhNJxS13j7+zU3GQ6+m04w0iysZbYrBBP4U7Gcp
         qojrDp6tGnQwwB/+lYH9EaMaDmBSKInWjgjq9ml68YbfpA+eZLC47AVVH+tStoHIxUgf
         fn+A==
X-Forwarded-Encrypted: i=1; AJvYcCX4ngHvrp/wu2jiscJIcS+MP9P4zpXN//dhvZBTn940c30KNudky7a0RwSuOA1trELhjoSU2G7qYmE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxDEelFWW05u9nf37Yuh5+E8WWXBLPrE+YshQzkJnQX4LJWUOBr
	NYCWIRzN/OAzFl0D6cuHnBZZsZLti9OSqKi03sr/AnfpLFPLJyGSMimgUh05LVI2B/azvohbtiQ
	kyBfN1R50MOzDBtw64xoRWqRp4YbMtRUK3sC8Z9LNF7XBwt2GBttSoOGEKNeczA==
X-Gm-Gg: ASbGncthOAnNFRDQDMruBtTY4rntGh5KB+0/DSdPoZP0y8PYT68iUvATAHSrytyx6qd
	t7b1rHdOnXx5cHNE5m8LE/GTU24lSVsYakJyhaA4E2DtWCnrXRd427yJ7VbLEmcsi/y9PZG+YWl
	JbqemyEOk7lx3pdUW87/UrzQVyV4OBkZsPxVrFX9JmeqmEZNj5Bs1oluyNo0v5pH9Q9+lt5Xxnp
	TS0wmb8WKfwWRGZqSDscdNOTuupQ88CVLnpvUbd7bvJ20/t2OvoCYfnzZTFiZktEQ09P3A3hDgB
	IiYt+JOSb5jxzd+bcNH62rn8eCEEnm89RMVcWrnmB7UoCBFraQ1oJ0OiRHkCYdusuvXt27gqwiM
	flxE9
X-Received: by 2002:a17:903:ac8:b0:240:52c8:2552 with SMTP id d9443c01a7336-24944ae192cmr137969755ad.43.1756791058812;
        Mon, 01 Sep 2025 22:30:58 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEw3Xr5ucLW7gxS8Pt5GghSq+s2xOFO77/qV2JjslaMbjeGR7mOxrLMI3CHW3mQnJwouM040w==
X-Received: by 2002:a17:903:ac8:b0:240:52c8:2552 with SMTP id d9443c01a7336-24944ae192cmr137969455ad.43.1756791058400;
        Mon, 01 Sep 2025 22:30:58 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3296cccd7d7sm3950352a91.10.2025.09.01.22.30.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Sep 2025 22:30:57 -0700 (PDT)
Date: Tue, 2 Sep 2025 13:30:52 +0800
From: Zorro Lang <zlang@redhat.com>
To: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, fstests@vger.kernel.org,
	Ritesh Harjani <ritesh.list@gmail.com>, john.g.garry@oracle.com,
	tytso@mit.edu, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: [PATCH v5 02/12] common/rc: Add _require_fio_version helper
Message-ID: <20250902053052.ajw6nr2yqbrk4qmf@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <cover.1755849134.git.ojaswin@linux.ibm.com>
 <955d47b2534d9236adbd2bbd13598bbd1da8fc04.1755849134.git.ojaswin@linux.ibm.com>
 <20250825160801.ffktqauw2o6l5ql3@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <aK8hUqdee-JFcFHn@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
 <20250828150905.GB8092@frogsfrogsfrogs>
 <aLHcgyWtwqMTX-Mz@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
 <20250830170907.htlqcmafntjwkjf4@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <aLWGEVZTPT4e7FAh@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aLWGEVZTPT4e7FAh@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>

On Mon, Sep 01, 2025 at 05:10:01PM +0530, Ojaswin Mujoo wrote:
> On Sun, Aug 31, 2025 at 01:09:07AM +0800, Zorro Lang wrote:
> > On Fri, Aug 29, 2025 at 10:29:47PM +0530, Ojaswin Mujoo wrote:
> > > On Thu, Aug 28, 2025 at 08:09:05AM -0700, Darrick J. Wong wrote:
> > > > On Wed, Aug 27, 2025 at 08:46:34PM +0530, Ojaswin Mujoo wrote:
> > > > > On Tue, Aug 26, 2025 at 12:08:01AM +0800, Zorro Lang wrote:
> > > > > > On Fri, Aug 22, 2025 at 01:32:01PM +0530, Ojaswin Mujoo wrote:
> > > > > > > The main motivation of adding this function on top of _require_fio is
> > > > > > > that there has been a case in fio where atomic= option was added but
> > > > > > > later it was changed to noop since kernel didn't yet have support for
> > > > > > > atomic writes. It was then again utilized to do atomic writes in a later
> > > > > > > version, once kernel got the support. Due to this there is a point in
> > > > > > > fio where _require_fio w/ atomic=1 will succeed even though it would
> > > > > > > not be doing atomic writes.
> > > > > > > 
> > > > > > > Hence, add an explicit helper to ensure tests to require specific
> > > > > > > versions of fio to work past such issues.
> > > > > > 
> > > > > > Actually I'm wondering if fstests really needs to care about this. This's
> > > > > > just a temporary issue of fio, not kernel or any fs usespace program. Do
> > > > > > we need to add a seperated helper only for a temporary fio issue? If fio
> > > > > > doesn't break fstests running, let it run. Just the testers install proper
> > > > > > fio (maybe latest) they need. What do you and others think?
> > > > 
> > > > Are there obvious failures if you try to run these new atomic write
> > > > tests on a system with the weird versions of fio that have the no-op
> > > > atomic= functionality?  I'm concerned that some QA person is going to do
> > > > that unwittingly and report that everything is ok when in reality they
> > > > didn't actually test anything.
> > > 
> > > I think John has a bit more background but afaict, RWF_ATOMIC support
> > > was added (fio commit: d01612f3ae25) but then removed (commit:
> > > a25ba6c64fe1) since the feature didn't make it to kernel in time.
> > > However the option seemed to be kept in place. Later, commit 40f1fc11d
> > > added the support back in a later version of fio. 
> > > 
> > > So yes, I think there are some version where fio will accept atomic=1
> > > but not act upon it and the tests may start failing with no apparent
> > > reason.
> > 
> > The concern from Darrick might be a problem. May I ask which fio commit
> > brought in this issue, and which fio commit fixed it? If this issue be
> > brought in and fixed within a fio release, it might be better. But if it
> > crosses fio release, that might be bad, then we might be better to have
> > this helper.
> 
> Hi Zorro, yes it does seem to cross version boundaries. The
> functionality was removed in fio v3.33 and added back in v3.38.  I

Thanks, if so I think let's have this helper for that issue :) But I think
we still prioritize _require_fio. If it helpless, then call _require_fio_version.

Reviewed-by: Zorro Lang <zlang@redhat.com>

Thanks,
Zorro

> confirmed this by running generic/1226 with both (for v3.33 run i
> commented out a few fio options that were added later but kept
> atomic=1):
> 
> Command: sudo perf record -e iomap:iomap_dio_rw_begin ./check generic/1226
> 
> perf script sample with fio v3.33:
> 
> fio    6626 [000]   777.668017: iomap:iomap_dio_rw_begin: <.sniip.> flags DIRECT|WRITE|AIO_RW dio_flags  aio 1
> 
> perf script sample with fio v3.39:
> 
> fio    9830 [000]   895.042747: iomap:iomap_dio_rw_begin: <.snip> flags ATOMIC|DIRECT|WRITE|AIO_RW dio_flags  aio 1
> 
> So as we can see, even though the test passes with atomic=1, fio is not
> sending the RWF_ATOMIC flag in the older version.
> 
> In which case I believe it should be okay to keep the helper, right?
> 
> Thanks,
> Ojaswin
> 
> > 
> > Thanks,
> > Zorro
> > 
> > > 
> > > Regards,
> > > ojaswin
> > > > 
> > > > --D
> > > > 
> > > > > > Thanks,
> > > > > > Zorro
> 

