Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C1BA263F5E
	for <linux-xfs@vger.kernel.org>; Thu,  5 Mar 2026 02:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772678345; cv=none; b=p/YZHZHz41nVlQ0HTI+UO9v+Lw6icQOWJGY1uP+Oy1R722PGOQlBdT9JXtjHuIjavg+M0t37jme0p+pOb5SRG9S4o3szIbLHm4KYosPlhvH+1NcsGIAb6eBomWMUHmLgbVimi3uoRI6dRG90RZbm8WD2GnTX2t/zpKH1DFdsbfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772678345; c=relaxed/simple;
	bh=7gQSYnEyDqz4ZDVnJD5nkJfCi1RiGgxBucE9LlPNzkY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GR1rGkt84DR3N/e5v/NCeN4pps9KxYXCr2D4upyCGClLiOCwWDMHb5xDWoKOQzwOdM0C7R9I4g8zMz1aBfU/S69zEqUyECLApSFRBXHGQAWb6QLkFw3YZotCSoaXXTTbhQTzL/wcqei2n2gA11jhaV5fS4l9++lzKude6EQ+B44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B76StDr4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B76StDr4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF16CC4CEF7;
	Thu,  5 Mar 2026 02:39:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772678344;
	bh=7gQSYnEyDqz4ZDVnJD5nkJfCi1RiGgxBucE9LlPNzkY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=B76StDr4lLDm0RcuhWlsCfVpjNFAQXVtr27ckK419IiZXEjFvsmMWO1nI6hMZxJA4
	 PbzIJXLUlQaC1TrspZ0F/wEpinxRKRfJH96bz/MiUm6j468ozKz3m/e+OZBLnXQfTR
	 U+9m7ajdsR5yUgf0Fo2nHi+/7/qwbadBzsz6uthn72AJvKWvrhBqE4UTGxOc+m5OIE
	 DVXATIuAIMymELghBCJ+9EGE3K1PVttiB4frW0GajoZQzWLFomDWEAk0+++IL/Qs10
	 /mca10MIeDXZbZBTYBus1NjyFLAoNsU7VLiiM7NF9nv0qYIdvUhU0zHbscv9TEx+2C
	 6kdoa6nUwrlSg==
Date: Wed, 4 Mar 2026 18:39:04 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: aalbersh@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/26] libfrog: add support code for starting systemd
 services programmatically
Message-ID: <20260305023904.GB57948@frogsfrogsfrogs>
References: <177249783165.482027.209169366483011357.stgit@frogsfrogsfrogs>
 <177249783347.482027.18301046401680150712.stgit@frogsfrogsfrogs>
 <aacCIcRTI6aDECTQ@infradead.org>
 <20260303155915.GI13868@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260303155915.GI13868@frogsfrogsfrogs>

On Tue, Mar 03, 2026 at 07:59:15AM -0800, Darrick J. Wong wrote:
> On Tue, Mar 03, 2026 at 07:45:37AM -0800, Christoph Hellwig wrote:
> > On Mon, Mar 02, 2026 at 04:34:36PM -0800, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > Add some simple routines for computing the name of systemd service
> > > instances and starting systemd services.  These will be used by the
> > > xfs_healer_start service to start per-filesystem xfs_healer service
> > > instances.
> > > 
> > > Note that we run systemd helper programs as subprocesses for a couple of
> > > reasons.  First, the path-escaping functionality is not a part of any
> > > library-accessible API, which means it can only be accessed via
> > > systemd-escape(1).  Second, although the service startup functionality
> > > can be reached via dbus, doing so would introduce a new library
> > > dependency.  Systemd is also undergoing a dbus -> varlink RPC transition
> > > so we avoid that mess by calling the cli systemctl(1) program.
> > 
> > Just curious: did you run this past the systemd folks?  Shelling out
> > always feel a bit iffy, and they're usually happy to help on how to
> > integrate with their services, so just asking might result in a better
> > way.
> 
> I'll do that, though even if they add a dbus/varlink endpoint for path
> escaping, it'll be a few releases more until we can depend on it
> existing in the distros. :(
> 
> Service startup can be done fairly easily with something like this,
> though obviously you'd want to do real error checking here:
> 
> static DBusConnection*
> connect_to_system_bus(void)
> {
> 	// Connect to the system bus (requires root or polkit permissions)
> 	DBusConnection *conn = dbus_bus_get(DBUS_BUS_SYSTEM, error);
> 
> 	return conn;
> }
> 
> int
> systemd_stop_service(
> 	const char *service_name)
> {
> 	DBusError error;
> 	DBusConnection *conn = connect_to_system_bus();
> 
> 	const char *manager_path = "/org/freedesktop/systemd1";
> 	const char *manager_interface = "org.freedesktop.systemd1.Manager";
> 	const char *method = "StopUnit";
> 
> 	DBusMessage *msg = dbus_message_new_method_call(
> 		"org.freedesktop.systemd1",
> 		manager_path,
> 		manager_interface,
> 		method
> 	);
> 
> 	const char *mode = "replace"; // Stop and replace existing job
> 	dbus_message_append_args(msg, DBUS_TYPE_STRING, &service_name,
> 			DBUS_TYPE_STRING, &mode, DBUS_TYPE_INVALID);
> 
> 	DBusMessage *reply =
> 			dbus_connection_send_with_reply_and_block(conn,
> 					msg, 5000, &error);
> 
> 	dbus_message_unref(reply);
> 	dbus_message_unref(msg);
> 	dbus_connection_unref(conn);
> 
> 	return 0;
> }
> 
> with the previously mentioned problem that now xfsprogs grows build and
> packaging dependencies on libdbus.  My guess is that it'll be a long
> time till they deprecate starting services over dbus.  AFAICT systemd in
> Trixie doesn't even expose varlink endpoints yet.
> 
> (Note that xfs_scrub_all already has a runtime dependency on
> python3-dbus)

Interim update -- just from looking at what
'systemctl restart --no-block' does, there's quite a lot of complexity
that the CLI hides.  If you ask it to start a service, it gives you back
a job object, then you can sit and wait to see what the result of the
job is, etc.  The above vibecoding was actually enough to start the
service, but TBH I think the dangers of shelling out are <cough> roughly
on the same level as all the crap you have to add to talk to systemd
over libdbus.

I'll try their mailing list, but first I have to wait for them to
approve my subscription, and only then can I ask...

--D
