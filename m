Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8BC23B995B;
	Wed, 29 Jul 2026 07:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785308556; cv=none; b=l2TwTxnbE/6WNer4PcO85JuEESbtEDmN/qRtqpxaYhFmQXrzGQjTgnpsuSs8bLVlPUK/rqppSOZeiA1tJL93LQa5HBUrny/bLt0aLZmqfIrTBahMwj2Whd3D5E5jWXnth220e9r0eKSbxZpyvQVie+M7njTp9WeIk87fitmi9Qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785308556; c=relaxed/simple;
	bh=GiIMadqESoaDARBcIqCq2nlQMIbzwAvX8MScQbI4nns=;
	h=MIME-Version:Content-Type:Subject:From:To:Cc:In-Reply-To:
	 References:Date:Message-Id; b=rfjF09nvGWUGkaHhboB1BQrhpWnRPEpUJX+JROrJg6StQNiiXvFSStG9GdKxusns5nWgol6UARiXR1YN9n8yFAz33+4p6cwLl+LfqjF46GB+lTYQJcsK4CdF8ugEFTXFSuJZPaKExfxUbRoOxppyyrVLarAsmKHnF5KWXrwMdWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kL5GAf78; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kL5GAf78"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3195D1F000E9;
	Wed, 29 Jul 2026 07:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785308555;
	bh=GiIMadqESoaDARBcIqCq2nlQMIbzwAvX8MScQbI4nns=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=kL5GAf78hxRO5pHL2xzefW5/9oddwRfnBNRty5+DgAiG1Dy7vlcs3qvvhoF5cqSfi
	 WyYEXZknF9YUjB8MRlFDnIQAqjbXzExKYou2K5WePAFKrHscVLtGM13G35vqTijvHz
	 vWwmKYXiWHHsERQspgsztAv6z2EVL54OM1RGH65FKd/sWIGo4q8ocYIu6vWmb7Mud/
	 Bu7nhuStdFbZxwzCUFngJwxi3BWNFeyNbBT1qTSyGM8juh7VEToEpXwl87FJMStDRR
	 7vVJkT1HDPctZ3LBkwq2a3yzFhgPL+HyVGNCt3cYQy+PJff8pqgr/llhbQu4BG4U0C
	 u8J2oqxOxUmnQ==
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] iomap: release the folio batch on iomap callback
 failures
From: Christian Brauner <brauner@kernel.org>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: Brian Foster <bfoster@redhat.com>, linux-fsdevel@vger.kernel.org, 
 linux-xfs@vger.kernel.org, hch@lst.de, djwong@kernel.org
In-Reply-To: <CAJnrk1YME2vEunO=y6WhqVr0hEO+QXihyrFNa+sisKR4j7-=tw@mail.gmail.com>
References: <20260728183005.92395-1-bfoster@redhat.com>
 <CAJnrk1Z=qohEjesFFn-YbmU0mqSPkMH_Jy+E6qSCw4pM8niPhw@mail.gmail.com>
 <amj_MJOEzLor4jMW@bfoster>
 <CAJnrk1YME2vEunO=y6WhqVr0hEO+QXihyrFNa+sisKR4j7-=tw@mail.gmail.com>
Date: Wed, 29 Jul 2026 09:02:31 +0200
Message-Id: <20260729-fernweh-ohnehin-befallen-061ddf9aa450@brauner>
X-Mailer: b4 0.16-dev-cca4b
X-Developer-Signature: v=1; a=openpgp-sha256; l=149; i=brauner@kernel.org;
 h=from:subject:message-id; bh=GiIMadqESoaDARBcIqCq2nlQMIbzwAvX8MScQbI4nns=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWRlLu309NUzys243ZY4i9VNoN8geHWS6Kmfsj/Wij6UM
 Pv5Mciio5SFQYyLQVZMkcWh3SRcbjlPxWajTA2YOaxMIEMYuDgFYCJXRBkZ2uZl1sbNWPLo58Of
 +1Z+ujiB1X53gc3G4CrZ/A8nL8Xu2szIcEdx/7lL/DY8TwKDHzIJnrI1/Oe7pvHWK/0Dn8t6Jkn
 v5AQA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

> I'll wait a day for anyone to object, and if no one does, I'll send v5
> tomorrow with your patch folded in.

Fold it, please. Thanks, Joanne!

