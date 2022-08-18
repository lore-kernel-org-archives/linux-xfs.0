Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B70C6C00140
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Aug 2022 17:03:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345358AbiHRRDc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Aug 2022 13:03:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345375AbiHRRCt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Aug 2022 13:02:49 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7813CAC8C;
        Thu, 18 Aug 2022 10:01:09 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 059FA1FD45;
        Thu, 18 Aug 2022 17:01:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1660842068;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KhtZwrDmDTXEuf9qp93qnXpXLLL8o6aGNkdAdLwLQPw=;
        b=L+XHxvkR716i6M9t+Wn3t+rOYgEufeUwnBC9AW2/4NQhdwfICBE94AVqlNpK3zNWiYptPI
        fBOWQzGlSJTVurHfenFvyKKu2PC6MGkFBZfQWZxGEiJT6n5Q1l5DHDkVx25EsI93G0Vq+5
        gzR5MZel4Ilq+57NLIzBL0XUj6PcuDs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1660842068;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KhtZwrDmDTXEuf9qp93qnXpXLLL8o6aGNkdAdLwLQPw=;
        b=zBb8gkibfMQD1SAsQwMlBVQ7vPc+GvdbY5QsExkBEm/aGbhnlbyooxOqHyHLVq/pGSlOW9
        7q7etrzWN7RMQjAA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 95A56133B5;
        Thu, 18 Aug 2022 17:01:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id U4SDIlNw/mJqOgAAMHmgww
        (envelope-from <pvorel@suse.cz>); Thu, 18 Aug 2022 17:01:07 +0000
Date:   Thu, 18 Aug 2022 19:01:05 +0200
From:   Petr Vorel <pvorel@suse.cz>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Eric Sandeen <sandeen@sandeen.net>,
        Dave Chinner <david@fromorbit.com>,
        linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Jan Kara <jack@suse.cz>, Hannes Reinecke <hare@suse.de>,
        linux-xfs@vger.kernel.org, ltp@lists.linux.it
Subject: Re: LTP test df01.sh detected different size of loop device in v5.19
Message-ID: <Yv5wUcLpIR0hwbmI@pevik>
Reply-To: Petr Vorel <pvorel@suse.cz>
References: <YvZc+jvRdTLn8rus@pevik>
 <YvZUfq+3HYwXEncw@pevik>
 <YvZTpQFinpkB06p9@pevik>
 <20220814224440.GR3600936@dread.disaster.area>
 <YvoSeTmLoQVxq7p9@pevik>
 <8d33a7a0-7a7c-47a1-ed84-83fd25089897@sandeen.net>
 <Yv5Z7eu5RGnutMly@pevik>
 <f03c6929-9a14-dd58-3726-dd2c231d0981@sandeen.net>
 <Yv5oaxsX6z2qxxF3@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yv5oaxsX6z2qxxF3@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> On Thu, Aug 18, 2022 at 11:05:33AM -0500, Eric Sandeen wrote:
> > On 8/18/22 10:25 AM, Petr Vorel wrote:
> > > Hi Eric, all,


> > ...


> > >> IOWS, I think the test expects that free space is reflected in statfs numbers
> > >> immediately after a file is removed, and that's no longer the case here. They
> > >> change in between the df check and the statfs check.

> > >> (The test isn't just checking that the values are correct, it is checking that
> > >> the values are /immediately/ correct.)

> > >> Putting a "sleep 1" after the "rm -f" in the test seems to fix it; IIRC
> > >> the max time to wait for inodegc is 1s. This does slow the test down a bit.

> > > Sure, it looks like we can sleep just 50ms on my hw (although better might be to
> > > poll for the result [1]), I just wanted to make sure there is no bug/regression
> > > before hiding it with sleep.

> > > Thanks for your input!

> > > Kind regards,
> > > Petr

> > > [1] https://people.kernel.org/metan/why-sleep-is-almost-never-acceptable-in-tests

> > >> -Eric

> > > +++ testcases/commands/df/df01.sh
> > > @@ -63,6 +63,10 @@ df_test()
> > >  		tst_res TFAIL "'$cmd' failed."
> > >  	fi

> > > +	if [ "$DF_FS_TYPE" = xfs ]; then
> > > +		tst_sleep 50ms
> > > +	fi
> > > +

> > Probably worth at least a comment as to why ...

Sure, that was just to document possible fix. BTW even 200ms was not reliable in
the long run => not a good solution.

> > Dave / Darrick / Brian - I'm not sure how long it might take to finish inodegc?
> > A too-short sleep will let the flakiness remain ...

> A fsfreeze -f / fsfreeze -u cycle will force all the background garbage
> collection to run to completion when precise free space accounting is
> being tested.
Thanks for a hint, do you mean to put it into df_test after creating file with
dd to wrap second df_verify (calls df) and df_check (runs stat and compare values)?
Because that does not help - it fails when running in the loop (managed to break after 5th run).

Kind regards,
Petr

df_test()
{
	local cmd="$1 -P"

	df_verify $cmd
	if [ $? -ne 0 ]; then
		return
	fi

	df_check $cmd
	if [ $? -ne 0 ]; then
		tst_res TFAIL "'$cmd' failed, not expected."
		return
	fi

	ROD_SILENT dd if=/dev/zero of=mntpoint/testimg bs=1024 count=1024

	if [ "$DF_FS_TYPE" = xfs ]; then
		fsfreeze -f $TST_MNTPOINT
	fi

	df_verify $cmd

	df_check $cmd
	if [ $? -eq 0 ]; then
		tst_res TPASS "'$cmd' passed."
	else
		tst_res TFAIL "'$cmd' failed."
	fi

	if [ "$DF_FS_TYPE" = xfs ]; then
		fsfreeze -u $TST_MNTPOINT
	fi

	ROD_SILENT rm -rf mntpoint/testimg

	# flush file system buffers, then we can get the actual sizes.
	sync
}

df_verify()
{
	$@ >output 2>&1
	if [ $? -ne 0 ]; then
		grep -q -E "unrecognized option | invalid option" output
		if [ $? -eq 0 ]; then
			tst_res TCONF "'$@' not supported."
			return 32
		else
			tst_res TFAIL "'$@' failed."
			cat output
			return 1
		fi
	fi
}

df_check()
{
	if [ "$(echo $@)" = "df -i -P" ]; then
		local total=$(stat -f mntpoint --printf=%c)
		local free=$(stat -f mntpoint --printf=%d)
		local used=$((total-free))
	else
		local total=$(stat -f mntpoint --printf=%b)
		local free=$(stat -f mntpoint --printf=%f)
		local used=$((total-free))
		local bsize=$(stat -f mntpoint --printf=%s)
		total=$((($total * $bsize + 512)/ 1024))
		used=$((($used * $bsize + 512) / 1024))
	fi

	grep ${TST_DEVICE} output | grep -q "${total}.*${used}"
	if [ $? -ne 0 ]; then
		echo "total: ${total}, used: ${used}"
		echo "df saved output:"
		cat output
		echo "df output:"
		$@
		return 1
	fi
}

> --D

> > -Eric

> > >  	ROD_SILENT rm -rf mntpoint/testimg

> > >  	# flush file system buffers, then we can get the actual sizes.

