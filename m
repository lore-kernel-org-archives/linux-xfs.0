Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0725DE92FC0
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Oct 2023 21:28:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230444AbjJEV2B (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Oct 2023 17:28:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230396AbjJEV2A (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Oct 2023 17:28:00 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D324295
        for <linux-xfs@vger.kernel.org>; Thu,  5 Oct 2023 14:27:58 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id d2e1a72fcca58-694f3444f94so1243239b3a.2
        for <linux-xfs@vger.kernel.org>; Thu, 05 Oct 2023 14:27:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1696541278; x=1697146078; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jRaWeVZ6OcHyQRjS8bbEdN/ktzf5DUFzF+BQIsZc7/c=;
        b=MLeWExAw/Z9pHMoZfTwVEYwD+0/BmXYw5iJHcQxkaeWw9Srk8/wLzefTm0Fio+o18L
         h5zXE9acvQ4CfB6h7jvdkMRC49C6lFj1ZhcpVeRxNyxaHbVMnE7VLVAsiCE/1E43tte7
         ntp75SBCMcJf5FItiZRjuFrf10lrCao9KcE8niab6hYcMh3Qhfzu/7y0vYHVZK8MEF+D
         UP4x7WqX29kAzxx/vOVY9yXxaMZprv+BwtVWe/tQmbplR5ws74k5ZFhFVTRc1ymPWi8x
         SP+vc1JfszxrMAEhp+gr8zvnpy8w2c25hF+5+qYYpRLTkjVo20uyD5MjY0Av2Is/hBtn
         K32w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696541278; x=1697146078;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jRaWeVZ6OcHyQRjS8bbEdN/ktzf5DUFzF+BQIsZc7/c=;
        b=ZBi9KX9JunUMsV+SsibXOhuM8FEWXDn1SfPyyoqHVYmChN5ftrrlT4+Si/UGuCefTO
         eEBoAtIIGB5xFXiqZxYd36+Mx6kRih2cF5xx4fXB9/dVJIDtrlKeBTL7j8CnRDUX7mQx
         r/ds+LUq/ETQx01YZByydOjNRWEyLw8SfOBWas8OHjC8gMyIQEWXnGi1TwatYyhEeyeQ
         O8rYXyLuQgaiRFvnyIDKdhfeuUj1gJR7Dz0N/0gNYWQA8ef773x1O2bV82cQBom2809X
         WyNuaOb7DwcV7zdXgYY4+T4ysy9nmyFkCPJLdZetjWn1q4eCOkwwb55LGLCEAod96rz9
         f0yg==
X-Gm-Message-State: AOJu0YxcXUcUknSDjmSdS43mMrfQYv2ABIUOPxwkRcV81ompj2Q186uv
        opvwCpz4c3p/zjWNg9pwoEHSTY0x6qfwbgZZeQY=
X-Google-Smtp-Source: AGHT+IE3mJ6iJHzoqKqHvAPHbD0+CsjvOHPUuQUmQt8a2eEWTRUk1FuAmddMxFvhb5IiBB6c6lT+aQ==
X-Received: by 2002:a05:6a20:7286:b0:15e:7323:5c0f with SMTP id o6-20020a056a20728600b0015e73235c0fmr7981113pzk.16.1696541278221;
        Thu, 05 Oct 2023 14:27:58 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-20-59.pa.nsw.optusnet.com.au. [49.180.20.59])
        by smtp.gmail.com with ESMTPSA id b1-20020a170902bd4100b001c0cb2aa2easm2216918plx.121.2023.10.05.14.27.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Oct 2023 14:27:57 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qoVsw-009wa9-0K;
        Fri, 06 Oct 2023 08:27:54 +1100
Date:   Fri, 6 Oct 2023 08:27:54 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Daan De Meyer <daan.j.demeyer@gmail.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: mkfs.xfs with --protofile does not copy extended attributes into
 the generated filesystem
Message-ID: <ZR8qWqksNx1kNhvi@dread.disaster.area>
References: <CAO8sHc=UYg7SFh8DWYq6wRet2CW2P8tNr-pWRNJ2wN=+_qW17g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAO8sHc=UYg7SFh8DWYq6wRet2CW2P8tNr-pWRNJ2wN=+_qW17g@mail.gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 05, 2023 at 10:37:34AM +0200, Daan De Meyer wrote:
> Hi,
> 
> It seems using --protofile ignores any extended attributes set on
> source files. I would like to generate an XFS filesystem using
> --protofile where extended attributes are copied from the source files
> into the generated filesystem. Any way to make this happen with
> --protofile?

mkfs.xfs doesn't have a '--protofile' option. It has a '-p <file>'
option for specifying a protofile - is that what you mean?

Regardless, there is no xattr support in mkfs/proto.c at all - it's
never been supported, and I don't recall anyone ever asking for it.
Hence it would have to be implemented from scratch if you need it.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
