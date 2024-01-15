Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com [209.85.167.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77B2E1B7FE
	for <linux-xfs@vger.kernel.org>; Mon, 15 Jan 2024 23:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="qXUdUhQH"
Received: by mail-oi1-f174.google.com with SMTP id 5614622812f47-3bd72353d9fso1813164b6e.3
        for <linux-xfs@vger.kernel.org>; Mon, 15 Jan 2024 15:01:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1705359682; x=1705964482; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=PfagMjm8PzVKMrg+wKZGGhVGZKWxo8fKxsB+lSjhnWs=;
        b=qXUdUhQHYDxYtmUGLlxvJGdIn9RqW5Wis3rzmRP77V1k/TvB7P68SUZhCxMAc0tFR3
         FPoXELWt+nsNEQrftMGCIm5E3TJB+dSCF+LjfbzHyGmSPwVv+s4POYiEpxur+fgD/iBU
         oszd/NIx28WLTqEraFxfxNeiNi4gBaLUousFugHInzGq7dH5jfVbStcsQD3Jnlj3cJkJ
         2VLE1uRf/NQ0H+ADOJEv0TM6A1Zmx+tPz1eOPEBPHczM0116nCFdmyYgezWE6iVa/GFA
         myI0BmfGN9f30Sqc8/+DJ0sEzVdPTmLOir1FyTQ1lSpdX14E480TrPpVHDgMi7OvmPG4
         4g8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705359682; x=1705964482;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PfagMjm8PzVKMrg+wKZGGhVGZKWxo8fKxsB+lSjhnWs=;
        b=hnjaFGoAn1/49XTJjqH49uBV2WBkyusa/+7+LlbclzBXBvw7wr1ql0yMurCeVw70KC
         Ov2Lx9bMwRHz0E8TLRBnLvv5ft/p3yBJHc/O34kEri6uMhcTgpzoNuuneR381O4il3+4
         iW3XOCUN5AAyCWqtCYG8LVZJLRLL2zXywyDwqyQZRkNn5hrLmXalT9vEpkbYhj0JOdgM
         iJ4Q7qEmm504ZY2/LLzZy0UILZGdlFVs66xoSrvHjiCV03i6tCVS7KM7CFsftW4RS2xJ
         dJqbu4I/jNrJ3VM2HsGPsZWuow/PVtd5O6vrJ7cX2fQ4AwibnpYs+t22WzF0zCf8wsh8
         PnAA==
X-Gm-Message-State: AOJu0Yz9yBnH60wCjru7t3rvA91PcZ7PrycMhRouvNKt8M/ENszftTS2
	V9/EC4ftNkJPyr4YXY738BB1gfqkN3m7dWYUO69pN4t0IgY=
X-Google-Smtp-Source: AGHT+IHkhOvev89Uh5PJlnac0EvcFktAeoujulicV1naw18eGcOKMz6cfBXcgmSg1iTx87RfrIm0Rw==
X-Received: by 2002:a05:6808:210e:b0:3bd:3530:d051 with SMTP id r14-20020a056808210e00b003bd3530d051mr8141840oiw.6.1705359682649;
        Mon, 15 Jan 2024 15:01:22 -0800 (PST)
Received: from dread.disaster.area (pa49-180-249-6.pa.nsw.optusnet.com.au. [49.180.249.6])
        by smtp.gmail.com with ESMTPSA id k2-20020aa790c2000000b006d9b32812c2sm8075868pfk.101.2024.01.15.15.01.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jan 2024 15:01:19 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
	by dread.disaster.area with esmtp (Exim 4.96)
	(envelope-from <dave@fromorbit.com>)
	id 1rPVxD-00AtJo-37;
	Tue, 16 Jan 2024 10:01:15 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.97)
	(envelope-from <dave@devoid.disaster.area>)
	id 1rPVxD-0000000H8VL-1khK;
	Tue, 16 Jan 2024 10:01:15 +1100
From: Dave Chinner <david@fromorbit.com>
To: linux-xfs@vger.kernel.org
Cc: willy@infradead.org,
	linux-mm@kvack.org
Subject: [PATCH 00/12] xfs: remove remaining kmem interfaces and GFP_NOFS usage
Date: Tue, 16 Jan 2024 09:59:38 +1100
Message-ID: <20240115230113.4080105-1-david@fromorbit.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series does two things. Firstly it removes the remaining XFS
specific kernel memory allocation wrappers, converting everything to
using GFP flags directly. Secondly, it converts all the GFP_NOFS
flag usage to use the scoped memalloc_nofs_save() API instead of
direct calls with the GFP_NOFS.

The first part of the series (fs/xfs/kmem.[ch] removal) is straight
forward.  We've done lots of this stuff in the past leading up to
the point; this is just converting the final remaining usage to the
native kernel interface. The only down-side to this is that we end
up propagating __GFP_NOFAIL everywhere into the code. This is no big
deal for XFS - it's just formalising the fact that all our
allocations are __GFP_NOFAIL by default, except for the ones we
explicity mark as able to fail. This may be a surprise of people
outside XFS, but we've been doing this for a couple of decades now
and the sky hasn't fallen yet.

The second part of the series is more involved - in most cases
GFP_NOFS is redundant because we are already in a scoped NOFS
context (e.g. transactions) so the conversion to GFP_KERNEL isn't a
huge issue.

However, there are some code paths where we have used GFP_NOFS to
prevent lockdep warnings because the code is called from both
GFP_KERNEL and GFP_NOFS contexts and so lockdep gets confused when
it has tracked code as GFP_NOFS and then sees it enter direct
reclaim, recurse into the filesystem and take fs locks from the
GFP_KERNEL caller. There are a couple of other lockdep false
positive paths that can occur that we've shut up with GFP_NOFS, too.
More recently, we've been using the __GFP_NOLOCKDEP flag to signal
this "lockdep gives false positives here" condition, so one of the
things this patchset does is convert all the GFP_NOFS calls in code
that can be run from both GFP_KERNEL and GFP_NOFS contexts, and/or
run both above and below reclaim with GFP_KERNEL | __GFP_NOLOCKDEP.

This means that some allocations have gone from having KM_NOFS tags
to having GFP_KERNEL | __GFP_NOLOCKDEP | __GFP_NOFAIL. There is an
increase in verbosity here, but the first step in cleaning all this
mess up is consistently annotating all the allocation sites with the
correct tags.

Later in the patchset, we start adding new scoped NOFS contexts to
cover cases where we really need NOFS but rely on code being called
to understand that it is actually in a NOFS context. And example of
this is intent recovery - allocating the intent structure occurs
outside transaction scope, but still needs to be NOFS scope because
of all the pending work already queued. The rest of the work is done
under transaction context, giving it NOFS context, but these initial
allocations aren't inside that scope. IOWs, the entire intent
recovery scope should really be covered by a single NOFS context.
The patch set ends up putting the entire second phase of recovery
(intents, unlnked list, reflink cleanup) under a single NOFS context
because we really don't want reclaim to operate on the filesystem
whilst we are performing these operations. Hence a single high level
NOFS scope is appropriate here.

The end result is that GFP_NOFS is completely gone from XFS,
replaced by correct annotations and more widely deployed scoped
allocation contexts. This passes fstests with lockdep, KASAN and
other debuggin enabled without any regressions or new lockdep false
positives.

Comments, thoughts and ideas?

----

Version 1:
- based on v6.7 + linux-xfs/for-next
