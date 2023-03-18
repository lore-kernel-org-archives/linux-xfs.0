Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A259C74A5B
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Mar 2023 00:37:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229967AbjCRAhp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Mar 2023 20:37:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229794AbjCRAho (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Mar 2023 20:37:44 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 980D12BEEC
        for <linux-xfs@vger.kernel.org>; Fri, 17 Mar 2023 17:37:33 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id a16so2707908pjs.4
        for <linux-xfs@vger.kernel.org>; Fri, 17 Mar 2023 17:37:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112; t=1679099853;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=zsqJ2FThmy4OXzq7vzmkyG0P9MJhsLVw+x1g28a4sdc=;
        b=1ukzmtXDsFNUp6jp1ICIw6l8dmlw9Px31lUTYNtTqcIbFmX8pKl7qpIpkGLDsRClpf
         +bqD1TPWFbteH4ZapgH5v5B5svVVcWDytzU4LmyhbsSfirRlC5zkNOPBCpcyROe7suvw
         sVyNg9WtfNVAfKG7dIMZ0PERv8PsZtb2Z0H4UJZ9LsHqGWYeddFLrCej5d6heJrOarJY
         Os0UQ//K+5YP9ASLl7bOlPIVCqhkuSgaor+8ySeJelGVGAd6lJQv8GeKlXwUvby5Ms87
         mktosNumzdUFD7JJSV9il2FaYEIiPovv0U8sWRSHc2MASRakuMNlO6MQx3kSnDQKfrC+
         /pRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679099853;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zsqJ2FThmy4OXzq7vzmkyG0P9MJhsLVw+x1g28a4sdc=;
        b=EMhKYYGgGSTwPYh+usxFqGH7mzeyNIIHnBO8SKFelbO3RTLylzIiGKEZR6FfIIhaN4
         YCCEBu0l05igq8Uybe2ODnF9X65Ty+6UNfxve9s48YkC7hAcOch+AIs03m4ETShXO0Qa
         T0Rrte6B3SYtmBdAaaj4wm7wT8wmv3EFPloKbA4DqfPK7TkeVmNX1lrecsezNSjsQarv
         yetm/BTw0eJi0wmWUrOpKHj1/IohF8k/DNXd581w28Wp93KSHm9/rZB1MXXN40ov7ahl
         c0FGvUvhXP3Wef9ctfmNhh233/pDJYGnANw1FHCrV2xEP1HkRufNf3y/7l2b5lKFeUmV
         lfpA==
X-Gm-Message-State: AO0yUKWQfE3plMe+XXFlEK3Q+K1ZqQc9YRChdygewrOXW7X8qvN8LMIh
        nV1hlujx/HoSbMucNc770l/5fg==
X-Google-Smtp-Source: AK7set/w/LZITNrsIWBwTVDruoNlaZ6AOU0yoW+i7jGUPAAcgmf/dJ5TXtlveacg9491eSTNP2vX2w==
X-Received: by 2002:a17:90a:8988:b0:237:401c:9bd5 with SMTP id v8-20020a17090a898800b00237401c9bd5mr9829412pjn.46.1679099853021;
        Fri, 17 Mar 2023 17:37:33 -0700 (PDT)
Received: from destitution (pa49-196-94-140.pa.vic.optusnet.com.au. [49.196.94.140])
        by smtp.gmail.com with ESMTPSA id l18-20020a17090add9200b0023530b1e4a0sm2062252pjv.2.2023.03.17.17.37.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Mar 2023 17:37:32 -0700 (PDT)
Received: from dave by destitution with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1pdKZd-000J7B-1A;
        Sat, 18 Mar 2023 11:37:29 +1100
Date:   Sat, 18 Mar 2023 11:37:29 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Hillf Danton <hdanton@sina.com>
Cc:     linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-mm@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        yebin10@huawei.com
Subject: Re: [PATCH 2/4] pcpcntrs: fix dying cpu summation race
Message-ID: <ZBUHyXkdzViG2VmT@destitution>
References: <20230315084938.2544737-1-david@fromorbit.com>
 <20230315233618.2168-1-hdanton@sina.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230315233618.2168-1-hdanton@sina.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 16, 2023 at 07:36:18AM +0800, Hillf Danton wrote:
> On 15 Mar 2023 19:49:36 +1100 Dave Chinner <dchinner@redhat.com>
> > @@ -141,11 +141,20 @@ static s64 __percpu_counter_sum_mask(struct percpu_counter *fbc,
> >  
> >  /*
> >   * Add up all the per-cpu counts, return the result.  This is a more accurate
> > - * but much slower version of percpu_counter_read_positive()
> > + * but much slower version of percpu_counter_read_positive().
> > + *
> > + * We use the cpu mask of (cpu_online_mask | cpu_dying_mask) to capture sums
> > + * from CPUs that are in the process of being taken offline. Dying cpus have
> > + * been removed from the online mask, but may not have had the hotplug dead
> > + * notifier called to fold the percpu count back into the global counter sum.
> > + * By including dying CPUs in the iteration mask, we avoid this race condition
> > + * so __percpu_counter_sum() just does the right thing when CPUs are being taken
> > + * offline.
> >   */
> >  s64 __percpu_counter_sum(struct percpu_counter *fbc)
> >  {
> > -	return __percpu_counter_sum_mask(fbc, cpu_online_mask);
> > +
> > +	return __percpu_counter_sum_mask(fbc, cpu_dying_mask);
> >  }
> >  EXPORT_SYMBOL(__percpu_counter_sum);
> >  
> > -- 
> > 2.39.2
> 
> Hm... the window of the race between a dying cpu and the sum of percpu counter
> spotted in commit f689054aace2 is stil open after a text-book log message.
> 
> 	cpu 0			cpu 2
> 	---			---
> 	percpu_counter_sum() 	percpu_counter_cpu_dead()
> 
> 	raw_spin_lock_irqsave(&fbc->lock, flags);
> 	ret = fbc->count;
> 	for_each_cpu_or(cpu, cpu_online_mask, cpu_dying_mask) {
> 		s32 *pcount = per_cpu_ptr(fbc->counters, cpu);
> 		ret += *pcount;
> 	}
> 	raw_spin_unlock_irqrestore(&fbc->lock, flags);
> 
> 				raw_spin_lock(&fbc->lock);
> 				pcount = per_cpu_ptr(fbc->counters, cpu);
> 				fbc->count += *pcount;
> 				*pcount = 0;
> 				raw_spin_unlock(&fbc->lock);

Their is no race condition updating fbc->count here - I explained
this in the cover letter. i.e. the sum in percpu_counter_sum() is to
a private counter and does not change fbc->count. Therefore we only
need/want to fold the dying cpu percpu count into fbc->count in the
CPU_DEAD callback.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
