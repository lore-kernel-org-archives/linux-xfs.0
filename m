Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 019863597B
	for <linux-xfs@vger.kernel.org>; Tue,  3 Mar 2026 15:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772553556; cv=none; b=c5DP6bKbq9waAHuwfrOuJFLvgKGNEaMJ2njSYeUTdhRebvBJjxBHDlX8F4IEGamIiuhkzTUyRk7dyJRAFZg0ojhKeFYFK8L1H92rieEPrhCVaEURv8d5/kbmpqtHwrAqh71bSaebsufAbtqwGuj4fVHDjVKzLu7eOP0C6an5TJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772553556; c=relaxed/simple;
	bh=dhpmBCf23B35u7vAQOJLD+gCzehyhnbwD07WMW70HNk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EEBcz2pALjM2gVrcomqM476q6TxWBnWhFmf0QmgIgHnkBc4+13KOu7n+COeK6eOaOTm00QoH2Iee83SRrNzO7T89+vK0Ha2VRZBqaSYN6SiRWSsB+wuc1pKcpCdkKF4hEMvWCss35UjQLrlXASYEUjOcrdCkFlSCpwpIpmTfYzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=avU7SHjJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="avU7SHjJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A756EC116C6;
	Tue,  3 Mar 2026 15:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772553555;
	bh=dhpmBCf23B35u7vAQOJLD+gCzehyhnbwD07WMW70HNk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=avU7SHjJ33/9r6XX2oum9W4HR9142JnWdLzS/Etx2WLWZh/dtpnMqDdfS1QtOzo8Z
	 vqKDBWolFsjEiXWEf92lCbD087ARkBCXNQbju+LtKxmz0m+TGmhCI5njzx1OK/qVIV
	 bwiDviwdzY29gcljf0yzboWA1/1vy06qRF4CG1PiITM3xnTTtnO2EzV4IGaPjY+qOI
	 oIZS9/MAHaSNV6wRTXm75TcXIeNEdzen2tEFkqvML5DkteVoOS/vkporN61fV3CwxI
	 o/QhPbFqmnGi1LFAeZ2/TXmyFX9vGiphtGFSHwOhfMhbV0tI6oStIcBvdARBEpO4/Q
	 WWjzo4+AbM4yQ==
Date: Tue, 3 Mar 2026 07:59:15 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: aalbersh@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/26] libfrog: add support code for starting systemd
 services programmatically
Message-ID: <20260303155915.GI13868@frogsfrogsfrogs>
References: <177249783165.482027.209169366483011357.stgit@frogsfrogsfrogs>
 <177249783347.482027.18301046401680150712.stgit@frogsfrogsfrogs>
 <aacCIcRTI6aDECTQ@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aacCIcRTI6aDECTQ@infradead.org>

On Tue, Mar 03, 2026 at 07:45:37AM -0800, Christoph Hellwig wrote:
> On Mon, Mar 02, 2026 at 04:34:36PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Add some simple routines for computing the name of systemd service
> > instances and starting systemd services.  These will be used by the
> > xfs_healer_start service to start per-filesystem xfs_healer service
> > instances.
> > 
> > Note that we run systemd helper programs as subprocesses for a couple of
> > reasons.  First, the path-escaping functionality is not a part of any
> > library-accessible API, which means it can only be accessed via
> > systemd-escape(1).  Second, although the service startup functionality
> > can be reached via dbus, doing so would introduce a new library
> > dependency.  Systemd is also undergoing a dbus -> varlink RPC transition
> > so we avoid that mess by calling the cli systemctl(1) program.
> 
> Just curious: did you run this past the systemd folks?  Shelling out
> always feel a bit iffy, and they're usually happy to help on how to
> integrate with their services, so just asking might result in a better
> way.

I'll do that, though even if they add a dbus/varlink endpoint for path
escaping, it'll be a few releases more until we can depend on it
existing in the distros. :(

Service startup can be done fairly easily with something like this,
though obviously you'd want to do real error checking here:

static DBusConnection*
connect_to_system_bus(void)
{
	// Connect to the system bus (requires root or polkit permissions)
	DBusConnection *conn = dbus_bus_get(DBUS_BUS_SYSTEM, error);

	return conn;
}

int
systemd_stop_service(
	const char *service_name)
{
	DBusError error;
	DBusConnection *conn = connect_to_system_bus();

	const char *manager_path = "/org/freedesktop/systemd1";
	const char *manager_interface = "org.freedesktop.systemd1.Manager";
	const char *method = "StopUnit";

	DBusMessage *msg = dbus_message_new_method_call(
		"org.freedesktop.systemd1",
		manager_path,
		manager_interface,
		method
	);

	const char *mode = "replace"; // Stop and replace existing job
	dbus_message_append_args(msg, DBUS_TYPE_STRING, &service_name,
			DBUS_TYPE_STRING, &mode, DBUS_TYPE_INVALID);

	DBusMessage *reply =
			dbus_connection_send_with_reply_and_block(conn,
					msg, 5000, &error);

	dbus_message_unref(reply);
	dbus_message_unref(msg);
	dbus_connection_unref(conn);

	return 0;
}

with the previously mentioned problem that now xfsprogs grows build and
packaging dependencies on libdbus.  My guess is that it'll be a long
time till they deprecate starting services over dbus.  AFAICT systemd in
Trixie doesn't even expose varlink endpoints yet.

(Note that xfs_scrub_all already has a runtime dependency on
python3-dbus)

--D
