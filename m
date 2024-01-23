Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BB06811EE;
	Tue, 23 Jan 2024 19:42:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706038936; cv=none; b=DqqNeCHAo15jGIfXwSp1RBFp/Y2C9BTS0B8Q+x1DrLNFmiiPyC6wpvs2X+jtt91+M7EVnntctTOEb4jg4fjw7Cv3/Cp8hVY0r+gPGxoaCM4syklLWgCbxR+fzncULwxo1fEuzA9DMlkdtHFLt/1/1VSnKppo3JmzX1Q8ZQ2k850=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706038936; c=relaxed/simple;
	bh=MgOh8qSAXOjVsURMY3TnuTHbI3cuWIPLfVNWhmhhrFI=;
	h=Date:Message-Id:From:To:Cc:Subject:In-Reply-To; b=HxhUTzfxaO9/PKaCK9uqRlMptxH2iGW+4hUP3rS0ogTthI84jdo2tnZS9cy/GFcIQxNCt0lsQdDfFqY04u+fLM9TBxuecRbJB1HJ2znGpcPQvmBSvxue4ueb6p3RRGl5VmnSV9OXigHs9KZNXH23qFnI08lrXqa2NrDDKlpfV7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CnyelzOk; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CnyelzOk"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-1d71c844811so23216995ad.3;
        Tue, 23 Jan 2024 11:42:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706038933; x=1706643733; darn=vger.kernel.org;
        h=in-reply-to:subject:cc:to:from:message-id:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=nOZhThgLXrk3cTydAduZLUncFHwC096MLmwwKuykovA=;
        b=CnyelzOkgv6xDYVC7yWR6wg5yoYS1SQ1Z26JkuU6aCR2/d1pHgN/TIq2/S3Zdhiqry
         r1OWymm5aCj+47mdTmoFSjW2N5UoBaivhqoB3NUAv/l8ObbDcoqICpsZEmMEgQSI7gNS
         YDXUqINGZdFcHaVuaw0JGG3S4EedYG//v0+oRJ06VdDejDbsKBWBJotA2pWCB0q0sdsg
         q7fhu5Jg9iSZaphuSJ0UnEWYWUEOUFad9mmkM/nIHfA4YsZYGm08quI7HzGgySiMnq2d
         DQNI29kVYyNt0Szq5zuF53uj8Xci3r16n6PBQAL0P66X3R9Wf7ICReblRCa8tZa/hpPb
         XmcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706038933; x=1706643733;
        h=in-reply-to:subject:cc:to:from:message-id:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nOZhThgLXrk3cTydAduZLUncFHwC096MLmwwKuykovA=;
        b=PH5jNoDWDoDFZMtqGwed9eI9HJhYzrvDKNums1+Ziry3Hme0GbfwYUY0ILU7YGYDEO
         ZWTWyCJw8GhXo6hfvsquABxhGLmGwVJhWQo2gqgK/WcvX6fhICUcOggOBenfBzYhNEW8
         NaXeiG0NOWanSoYUwVKirWyifXD1TuQQk6BVOG9vLXuyt6TpWjfAEPWlG2tBmOUsi756
         OvfPMOEEuSV6IAHCIN2b41CsnLqovi9JGBmarlO688BotjZOORFbceLAoEokKw136Ml2
         NexxQxv83DQc2QQy/tlIqdaD2EX1gROyIP0aMY9v2poweD9Go7csa43PAFLqOCiz1HAI
         KANA==
X-Gm-Message-State: AOJu0YytCZTt0UbK+lMSYvSpfTtSwPMHAatNliFdH63HdQUvUbEvyGDE
	3zEF+fw1ffY1gDyMVXnt+e2x6UjPAv5/eayEuSy6Czl447nHSsw4S0luHipY
X-Google-Smtp-Source: AGHT+IGyNHmGvsgwDy947E3qTBE3jH4X7oLo4cfW+ZeSSX5HBS7jAOJOmCfFp30dyMxIyteA5k4u2A==
X-Received: by 2002:a17:902:ce8b:b0:1d6:f17e:a03d with SMTP id f11-20020a170902ce8b00b001d6f17ea03dmr4096509plg.95.1706038932878;
        Tue, 23 Jan 2024 11:42:12 -0800 (PST)
Received: from dw-tp ([49.205.218.89])
        by smtp.gmail.com with ESMTPSA id e12-20020a17090301cc00b001d753a682e6sm3630397plh.96.2024.01.23.11.42.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jan 2024 11:42:12 -0800 (PST)
Date: Wed, 24 Jan 2024 01:12:07 +0530
Message-Id: <87frynkfao.fsf@doe.com>
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Pankaj Raghav <p.raghav@samsung.com>, Dave Chinner <david@fromorbit.com>, "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>
Cc: zlang@redhat.com, fstests@vger.kernel.org, djwong@kernel.org, mcgrof@kernel.org, gost.dev@samsung.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 0/2] fstest changes for LBS
In-Reply-To: <803025df-5381-494d-9325-dd0a45312b8b@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>

Pankaj Raghav <p.raghav@samsung.com> writes:

>>> CCing Ritesh as I saw him post a patch to fix a testcase for 64k block size.
>> 
>> Hi Pankaj,
>> 
>> So I tested this on Linux 6.6 on Power8 qemu (which I had it handy).
>> xfs/558 passed with both 64k blocksize & with 4k blocksize on a 64k
>> pagesize system.

Ok, so it looks like the testcase xfs/558 is failing on linux-next with
64k blocksize but passing with 4k blocksize.
It thought it was passing on my previous linux 6.6 release, but I guess
those too were just some lucky runs. Here is the report -

linux-next: xfs/558 aggregate results across 11 runs: pass=2 (18.2%), fail=9 (81.8%)
v6.6: xfs/558 aggregate results across 11 runs: pass=5 (45.5%), fail=6 (54.5%)

So I guess, I will spend sometime analyzing why the failure.

Failure log
================
xfs/558 36s ... - output mismatch (see /root/xfstests-dev/results//xfs_64k_iomap/xfs/558.out.bad)
    --- tests/xfs/558.out       2023-06-29 12:06:13.824276289 +0000
    +++ /root/xfstests-dev/results//xfs_64k_iomap/xfs/558.out.bad       2024-01-23 18:54:56.613116520 +0000
    @@ -1,2 +1,3 @@
     QA output created by 558
    +Expected to hear about writeback iomap invalidations?
     Silence is golden
    ...
    (Run 'diff -u /root/xfstests-dev/tests/xfs/558.out /root/xfstests-dev/results//xfs_64k_iomap/xfs/558.out.bad'  to see the entire diff)

HINT: You _MAY_ be missing kernel fix:
      5c665e5b5af6 xfs: remove xfs_map_cow

-ritesh

>
> Thanks for testing it out. I will investigate this further, and see why
> I have this failure in LBS for 64k and not for 32k and 16k block sizes.
>
> As this test also expects some invalidation during the page cache writeback,
> this might an issue just with LBS and not for 64k page size machines.
>
> Probably I will also spend some time to set up a Power8 qemu to test these failures.
>
>> However, since on this system the quota was v4.05, it does not support
>> bigtime feature hence could not run xfs/161. 
>> 
>> xfs/161       [not run] quota: bigtime support not detected
>> xfs/558 7s ...  21s
>> 
>> I will collect this info on a different system with latest kernel and
>> will update for xfs/161 too.
>> 
>
> Sounds good! Thanks!
>
>> -ritesh
